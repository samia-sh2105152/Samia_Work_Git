const taskForm = document.getElementById('taskForm');
const taskInput = document.getElementById('taskInput');
const taskList = document.getElementById('taskList');

let tasks = []; // local in-memory storage

// Render tasks
function renderTasks() {
  taskList.innerHTML = '';
  tasks.forEach((task, index) => {
    const li = document.createElement('li');
    li.innerHTML = `
      <label>
        <input type="checkbox" ${task.completed ? 'checked' : ''} disabled />
        ${task.text}
      </label>
      <button onclick="deleteTask(${index})">❌</button>
    `;
    taskList.appendChild(li);
  });
}

// Add task
taskForm.addEventListener('submit', function (e) {
  e.preventDefault();
  const text = taskInput.value.trim();
  if (!text) return;
  tasks.push({ text, completed: false });
  taskInput.value = '';
  renderTasks();
});

// Delete task
function deleteTask(index) {
  tasks.splice(index, 1);
  renderTasks();
}

// Initial call
renderTasks();
