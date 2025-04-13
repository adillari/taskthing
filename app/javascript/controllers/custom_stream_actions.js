const StreamActions = {};

StreamActions.clear_new_task_form_inputs = function () {
  const newTaskForm = this.targetElements[0];

  newTaskForm.querySelector("input[name='task[title]']").value = null;
  newTaskForm.querySelector("textarea[name='task[description]']").value = null;
};

StreamActions.place_new_task_unless_up_to_date = function () {
  const newTaskForm = this.targetElements[0];
  const fragment = this.templateElement.content;
  const version = fragment.firstElementChild.dataset.version;

  if (document.getElementById("version")?.innerText !== version) {
    newTaskForm.insertAdjacentElement("afterend", fragment.firstElementChild);
  }
};

StreamActions.update_task_unless_up_to_date = function () {
  const lane = this.targetElements[0];
  const ul = lane.querySelector("ul");
  const fragment = this.templateElement.content;
  const version = fragment.firstElementChild.dataset.version;
  const taskId = fragment.firstElementChild.id;
  const position = Number(
    fragment.firstElementChild.querySelector("input[name='task[position]']")
      .value,
  );

  if (document.getElementById("version")?.innerText !== version) {
    document.getElementById(taskId).remove();
    ul.insertBefore(
      fragment.firstElementChild,
      ul.children[position].nextSibling,
    );
  }
};

export { StreamActions };
