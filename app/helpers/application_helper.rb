module ApplicationHelper
  def header
    safe_join([left_header, right_header])
  end

  def modal(title:, &)
    turbo_frame_tag(:modal) do
      tag.div(
        class: "bg-black/50 backdrop-blur fixed top-0 left-0 w-full h-full z-10",
        data: { application_target: :modal, action: "click->application#removeModal" },
      ) do
        tag.div(
          class: "mx-auto max-w-96 bg-zinc-900 rounded-lg p-4 shadow-xl shadow-sm fixed inset-x-2 top-1/3 z-20",
          data: { action: "click->application#stopPropagation" },
        ) do
          safe_join([
            tag.div(class: "flex font-semibold mb-4") do
              safe_join([
                tag.span(title, class: "overflow-hidden"),
                tag.button(
                  "close",
                  class: "material-symbols-outlined ml-auto cursor-pointer",
                  data: { action: "application#removeModal" },
                ),
              ])
            end,
            capture(&),
          ])
        end
      end
    end
  end

  def source_code_link
    "https://github.com/adillari/taskthing"
  end

  private

  # these header methods can be cleaned up a lot
  def left_header
    if controller_name == "board_settings"
      safe_join([boards_link, right_chevron, board_link, right_chevron, board_settings_link])
    elsif @board
      safe_join([boards_link, right_chevron, board_link, board_settings_link(class: "pl-2")])
    elsif @boards
      boards_link
    else
      link_to("Taskthing.io", root_path, class: "text-xl font-bold")
    end
  end

  def boards_link
    link_to(t("boards"), boards_path, class: "text-xl font-bold")
  end

  def right_chevron
    tag.span("chevron_right", class: "material-symbols-outlined pl-0.5")
  end

  def board_link
    link_to(@board.title, board_path(@board), class: "text-xl font-bold")
  end

  def board_settings_link(options = { class: "" })
    link_to("settings", board_settings_path(@board), class: ["material-symbols-outlined", options[:class]].join(" "))
  end

  def right_header
    tag.div(class: "ml-auto flex items-center gap-2") do
      if authenticated?
        safe_join([
          tag.dig(data: { application_target: :indicator, turbo_temporary: "" }, hidden: true) do
            tag.div(class: "lds-ring flex items-center") do
              safe_join([tag.div, tag.div, tag.div, tag.div])
            end
          end,
          link_to("logout", session_path, class: "material-symbols-outlined", data: { turbo_method: :delete }),
        ])
      else
        link_to(t("login"), new_session_path, class: "button-outlined float-right border-violet-700")
      end
    end
  end
end
