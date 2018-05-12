module ApplicationHelper
  def flash_messages
    viewable = [:notice, :alert]

    classes = {
      notice: 'alert alert-success alert-dismissable',
      alert: 'alert alert-danger alert-dismissable',
      q_saved: 'alert alert-success alert-q-saved alert-dismissable'
    }

    dismiss_button = '<button name="button" type="button" class="close" data-dismiss="alert">×</button>'.html_safe

    html = ''

    flash.each do |key, message|
      next unless key.to_sym.in?(viewable)
      html += content_tag(:div, dismiss_button + message.html_safe, class: classes[key.to_sym])
    end

    html.html_safe
  end
end
