module ApplicationHelper
  def header
    safe_join([left_header, right_header])
  end

  def modal(title:, &)
    turbo_frame_tag(:modal) do
      tag.div(
        class: "bg-black bg-opacity-50 backdrop-blur fixed top-0 left-0 w-full h-full z-10",
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

  private

  def left_header
    if controller_name == "board_settings"
      safe_join([
        link_to("Boards", boards_path, class: "text-xl font-bold"),
        tag.span("chevron_right", class: "material-symbols-outlined pl-0.5"),
        link_to(@board.title, board_path(@board), class: "text-xl font-bold"),
        tag.span("chevron_right", class: "material-symbols-outlined pl-0.5"),
        link_to("settings", board_settings_path(@board), class: "material-symbols-outlined"),
      ])
    elsif @board
      safe_join([
        link_to("Boards", boards_path, class: "text-xl font-bold"),
        tag.span("chevron_right", class: "material-symbols-outlined pl-0.5"),
        link_to(@board.title, board_path(@board), class: "text-xl font-bold"),
        link_to("settings", board_settings_path(board_id: @board.id), class: "material-symbols-outlined pl-2"),
      ])
    elsif @boards
      link_to("Boards", boards_path, class: "text-xl font-bold")
    else
      link_to("Taskthing.io", root_path, class: "text-xl font-bold")
    end
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
        link_to("Login", new_session_path, class: "button-outlined float-right border-violet-700")
      end
    end
  end
end
