class Admin::ClipboardController < AlchemyController
  
  layout 'alchemy'
  
  before_filter :set_translation
  
  def index
    clipboard = get_clipboard(params[:remarkable_type].tableize)
    @clipboard_items = params[:remarkable_type].classify.constantize.all_from_clipboard(clipboard)
    render :layout => false
  end
  
  def insert
    @clipboard = get_clipboard(params[:remarkable_type].tableize)
    @item = params[:remarkable_type].classify.constantize.find(params[:remarkable_id])
    unless @clipboard.include?(params[:remarkable_id])
      @clipboard.push(params[:remarkable_id])
    end
  rescue Exception => e
    exception_handler(e)
  end
  
  def remove
    @clipboard = get_clipboard(params[:remarkable_type].tableize)
    @item = params[:remarkable_type].classify.constantize.find(params[:remarkable_id])
    @clipboard.delete(params[:remarkable_id])
  rescue Exception => e
    exception_handler(e)
  end
  
  def clear
    session[:clipboard] = {}
    render :update do |page|
      page.replace("clipboard_items", "<p>#{ _('No items in your clipboard') }</p>")
      page << "jQuery('#clipboard_button .icon.clipboard').removeClass('full')"
    end
  end
  
end
