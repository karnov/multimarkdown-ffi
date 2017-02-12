require 'ffi'
require 'ffi-compiler/loader'
require 'yaml'
require_relative 'multimarkdown/version'

# Ruby wrapper for Fletcher Penney's implementation of Multimarkdown
#
# Example:
#     >> puts Multimarkdown.new("Hello, World.").to_html
#     <p>Hello, World.</p>
#
class Multimarkdown
  extend FFI::Library
  ffi_lib FFI::Compiler::Loader.find('multimarkdown')

  ExportFormat = enum(
    :original,
    :html,
    :text,
    :latex,
    :memoir,
    :beamer,
    :opml,
    :odf,
    :rtf,
    :critic_accept,
    :critic_reject,
    :critic_html_highlight,
    :lyx,
    :toc
  )

  ParserExtensions = enum(
    :compatibility,                  1 << 0,  # Markdown compatibility mode (disables all other options)
    :complete,                       1 << 1,  # Force complete document
    :snippet,                        1 << 2,  # Force snippet only
    :head_closed,                    1 << 3,  # For use by parser
    :smart_quotes,                   1 << 4,  # Use Smart quotes
    :footnotes,                      1 << 5,  # Use Footnotes
    :no_anchors,                     1 << 6,  # Don't add anchors to headers, etc.
    :filter_styles,                  1 << 7,  # Filter out style blocks
    :filter_html,                    1 << 8,  # Filter out raw HTML
    :process_html,                   1 << 9,  # Process Markdown inside HTML
    :no_metadata,                    1 << 10, # Don't parse Metadata
    :obfuscate_email_addresses,      1 << 11, # Mask email addresses
    :critic,                         1 << 12, # Critic Markup Support
    :critic_markup_accept_all,       1 << 13, # CriticMarkup: Accept all proposed changes
    :critic_markup_reject_all,       1 << 14, # CriticMarkup: Reject all proposed changes
    :random_footnote_anchor_numbers, 1 << 15, # Use random numbers for footnote link anchors
    :headingsection,                 1 << 16, # Group blocks under parent heading
    :escaped_line_breaks,            1 << 17, # Escaped line break
    :no_strong,                      1 << 18, # Don't allow nested <strong>'s
    :no_emph,                        1 << 19, # Don't allow nested <emph>'s
    :fake,                           1 << 31, # 31 is highest number allowed
  )

  attach_function :markdown_to_string,
    [:string, :int, ExportFormat], :string

  attach_function :has_metadata, [:string, :int], :bool
  attach_function :extract_metadata_keys, [:string, :int], :string
  attach_function :extract_metadata_value, [:string, :int, :string], :string
  attach_function :mmd_version, [], :string

  MMD_VERSION = mmd_version

  ParserExtensions.to_h.keys.each(&method(:attr_accessor))

  # Create a new Multimarkdown processor. The `text` argument is a string
  # containing Multimarkdown text. Variable other arguments may be supplied to
  # set various processing options.
  def initialize(text, *parser_extensions)
    @text = text
    parser_extensions.each do |ext|
      raise "Unknown extension: #{ext.inspect}" unless
        ParserExtensions.to_h.keys.include?(ext.to_sym)
      send("#{ext}=", true)
    end
  end

  def parser_extensions
    extensions = 0
    ParserExtensions.to_h.each do |ext_name, ext_value|
      extensions |= ext_value if send(ext_name) == true
    end
    extensions
  end

  def metadata_keys
    extract_metadata_keys(@text, parser_extensions)
      .split("\n")
      .map { |s| s.force_encoding("UTF-8") }
  end

  def metadata_value(key)
    extract_metadata_value(@text, parser_extensions, key)
      .strip
      .force_encoding("UTF-8")
  end

  # Returns a Hash cointaining all Metadata
  #
  def metadata(key = nil)
    @cached_metadata ||= begin
      @cached_metadata = {}
      metadata_keys.each do |k|
        @cached_metadata[k.downcase] = metadata_value(k)
      end
      @cached_metadata
    end

    return @cached_metadata[key.to_s.downcase] if key
    @cached_metadata.dup
  end

  def method_missing(name, *args, &block)
    export_format = name[/\Ato_(?<format>\w+)/, :format]
    export_format_val = ExportFormat.find(export_format.to_sym)
    if export_format_val
      string = markdown_to_string(@text, parser_extensions, export_format_val)
      return string.force_encoding("UTF-8")
    end
    super
  end

  def respond_to_missing?(name, *)
    name =~ /to_(\w+)/ || super
  end
end
