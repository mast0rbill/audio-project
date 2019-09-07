public class InputTest {
  AudioPlayer player;
  FFT fft;
  
  public InputTest() {
    player = minim.loadFile("test.mp3");
    fft = new FFT(player.bufferSize(), player.sampleRate());

    player.play();
  }

  public void Update() {
    background(0);
    stroke(255);

    // amplitude
    int leftOffset = 50;
    int rightOffset = 100;
    int amplitude = 50;

    for (int i = 0; i < player.bufferSize() - 1; i++) {
      float left1 = leftOffset + player.left.get(i) * amplitude;
      float left2 = leftOffset + player.left.get(i + 1) * amplitude;
      float right1 = rightOffset + player.right.get(i) * amplitude;
      float right2 = rightOffset + player.right.get(i + 1) * amplitude;
      line(i, left1, i+1, left2);
      line(i, right1, i+1, right2);
    }

    // frequency
    fft.forward(player.mix);
    noStroke();
    fill(255);
    for (int i = 0; i < 250; i++) {
      float b = fft.getBand(i);
      rect(i * 5, height - b * 5, 5, b * 5);
    }
  }

  public void Destruct() {
    player.close();
  }
}
