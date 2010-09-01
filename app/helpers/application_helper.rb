# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def side_column_links
    str = "<h3 class=\"head\">#{link_to 'All Multimedia', '#nogo', {:hreflang => 'The media management system stores, organize and display pictures, videos and texts.'}}</h3>\n<ul>\n" +
          "<li>#{link_to 'Home', media_path, {:hreflang => 'Browse pictures, videos, and texts.'}}</li>\n" +
          "<li>#{link_to 'Advanced Search', new_media_search_path, {:hreflang => 'Search pictures, videos, and texts.'}}</li>\n" +
          "<li>#{link_to "Collections <em class=\"browse\">Browse</em>", collections_path, {:hreflang => 'Browse pictures, videos, and texts by collection.'}}</li>\n" +
          "<li>#{link_to "Cultures <em class=\"browse\">Browse</em>", ethnicities_path, {:hreflang => 'Browse pictures, videos, and texts by socio-cultural group.'}}</li>\n" +
          "<li>#{link_to "Subjects <em class=\"browse\">Browse</em>", subjects_path, {:hreflang => 'Browse pictures, videos, and texts by subject.'}}</li>\n"
    authorized_only(hash_for_admin_path) { str += "<li>#{link_to 'Administration', admin_path, {:hreflang => 'Manage countries, keywords, glossaries, static pages, copyright holders, organizations, projects, sponsors, translations, people, users, roles, themes, languages, settings and media importation.'}}</li>\n" }
    str += "</ul>"
    return str
  end
  
  def stylesheet_files
    super + ['mms', 'jquery-ui-tabs']
  end
  
  def javascript_files
    super + ['jquery-ui-tabs']
  end
  
  def javascripts
    [super, include_tiny_mce_if_needed].join("\n")
  end
  
  def secondary_tabs_config
    # The :index values are necessary for this hash's elements to be sorted properly
    {
      :home => {:index => 1, :title => "Home", :url => "#{ActionController::Base.relative_url_root.to_s}/"},
      :search => {:index => 2, :title => "Search", :url => new_media_search_url},
      :browse => {:index => 3, :title => "Browse", :url => collections_url},
      :picture => {:index => 4, :title => Picture.human_name.titleize.pluralize, :url => media_path(:type => 'Picture')},
      #:audio => {:index => 5, :title => "Audio", :url => new_media_search_url},
      :video => {:index => 5, :title => Video.human_name.titleize.pluralize, :url => media_path(:type => 'Video')},
      #:immersive => {:index => 7, :title => "Immersive", :url => new_media_search_url},
      :document => {:index => 6, :title => Document.human_name.titleize.pluralize, :url => media_path(:type => 'Document')}
      #:biblio => {:index => 9, :title => "Biblio", :url => sources_url},
    }
  end
  
  def secondary_tabs(current_tab_id=:browse)

    @tab_options ||= {}
    @tab_options[:urls] ||= {}
    @tab_options[:counts] ||= {}
    @tab_options[:counts] = tab_counts_for_all_media if @tab_options[:counts].blank?
    
    tabs = secondary_tabs_config
    
    current_tab_id = :browse unless tabs.has_key? current_tab_id
    
    @tab_options[:urls].each do |tab_id, url|
      tabs[tab_id][:url] = url unless tabs[tab_id].nil? || url.nil?
    end
    
    @tab_options[:counts].each do |tab_id, count|
      unless tabs[tab_id].nil? || count.nil?
        if count == 0
          tabs.delete(tab_id)
        else
          tabs[tab_id][:title] += " (#{number_with_delimiter(count.to_i, :delimiter => ',')})"
        end
      end
    end
    
    tabs[current_tab_id][:url] = "#media_main"
    current_tab_index = 1
    tab_index = 0
    tabs = tabs.sort{|a,b| a[1][:index] <=> b[1][:index]}.collect{|tab_id, tab| 
      current_tab_index = tab_index if tab_id == current_tab_id
      tab_index += 1
      [tab[:title], tab[:url]]
    }
    
    un_secondary_tabs tabs, current_tab_index
  end
  
  def tab_counts_for_element(element)
    counts = {}
    Medium::TYPES.each do |type, display_names|
      counts[type] = element.media_count(:type => type.to_s.classify)
    end
    counts
  end
  
  def tab_urls_for_element(element)
    urls = {}
    id_method = :id
    id_method = :fid if element.class.name == "Place"
    element_id = element.send(id_method)
    element_name = (element.class.name.underscore+"_id").to_sym
    Medium::TYPES.each do |type, display_names|
      urls[type] = media_path(element_name => element_id, :type => type.to_s.classify)
    end
    urls
  end
  
  def tab_counts_for_search(search)
    counts = {}
    Medium::TYPES.each do |type, display_names|
      counts[type] = Medium.media_count_search(search, type.to_s.classify)
    end
    counts
  end
  
  def tab_urls_for_search(search)
    urls = {}
    Medium::TYPES.each do |type, display_names|
      urls[type] = media_searches_path(search.merge({:media_type => type.to_s.classify}))
    end
    urls
  end
  
  def tab_counts_for_all_media
    counts = {}
    Medium::TYPES.each do |type, display_names|
      counts[type] = Medium.media_count_for_type(type.to_s.classify)
    end
    counts
  end
end

module ActionView
  module Helpers
    module PaginationHelper
      def pagination_links_remote(paginator, page_options={}, ajax_options={}, html_options={})
        name = page_options[:name] || DEFAULT_OPTIONS[:name]
        params = (page_options[:params] || DEFAULT_OPTIONS[:params]).clone

        pagination_links_each(paginator, page_options) do |n|
          params[name] = n
          ajax_options[:url] = params
          link_to_remote(n.to_s, ajax_options, html_options)
        end
      end
    end # PaginationHelper
  end # Helpers
end # ActionView
