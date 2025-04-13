const StreamActions = {}

StreamActions.clear_new_task_form_inputs = function() {
  const newTaskForm = this.targetElements[0]

  newTaskForm.querySelector("input[name='task[title]']").value = null;
  newTaskForm.querySelector("textarea[name='task[description]']").value = null;
}

StreamActions.place_new_task_unless_up_to_date = function() {
  const newTaskForm = this.targetElements[0]
  const version = this.templateElement.dataset.version

  if (document.getElementById('version')?.innerText !== version) {
    const fragment = this.templateElement.content
    newTaskForm.insertAdjacentElement("afterend", fragment.firstElementChild)
  }
}

export { StreamActions }
