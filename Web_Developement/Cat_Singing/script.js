function goToFlow2() {
    document.getElementById("flow1").style.display = "none";
    document.getElementById("feelCard").style.display = "block";
  
    const cat = document.getElementById("spinCat");
    const sound = document.getElementById("song");
  
    cat.classList.remove("rotating"); 
    void cat.offsetWidth; 
    cat.classList.add("rotating");
  
    isPaused = false;
    document.getElementById("pauseBtn").src = "assets/Media/pause.svg";
  
    sound.currentTime = 0;
    sound.play();
  }

  // Pause logic
  let isPaused = false;
  document.getElementById("pauseBtn").addEventListener("click", () => {
    const cat = document.getElementById("spinCat");
    const sound = document.getElementById("song");
  
    if (isPaused) {
      cat.classList.add("rotating");
      sound.play();
      document.getElementById("pauseBtn").src = "assets/Media/pause.svg"; 
    } else {
      cat.classList.remove("rotating");
      sound.pause();
      document.getElementById("pauseBtn").src = "assets/Media/Play@2x.png";
      
    }
  
    isPaused = !isPaused;
  });
  
  // Back to Flow 1
  document.getElementById("rewindBtn").addEventListener("click", () => {
    document.getElementById("feelCard").style.display = "none";
    document.getElementById("flow1").style.display = "block";
  
    const cat = document.getElementById("spinCat");
    cat.classList.remove("rotating");
    const pauseBtn = document.getElementById("pauseBtn");
    pauseBtn.src = "assets/Media/pause.svg";
    isPaused = false;
    const sound = document.getElementById("song");
    sound.pause();
    sound.currentTime = 0;
  });
  const song = document.getElementById("song");
const progressBar1 = document.getElementById("progressBar1");
const progressBar2 = document.getElementById("progressBar2");

song.addEventListener("timeupdate", () => {
  const percent = (song.currentTime / song.duration) * 100;

  // Check which card is active and update the correct bar
  if (document.getElementById("feelCard").style.display === "block") {
    progressBar2.style.width = percent + "%";
  } else {
    progressBar1.style.width = percent + "%";
  }
});
