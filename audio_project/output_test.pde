public class OutputTest {
  AudioOutput out;
  FFT fft;
  
  public float tempo = 30;
  public MyInstrument instrument;
  
  private Queue<String[]> playSeq = new LinkedList<String[]>();
  private boolean playingSequence = false;
  private long lastPlayedTime;

  public OutputTest() {
    out = minim.getLineOut(Minim.STEREO); 
    instrument = new MyInstrument(out);
  }

  public void PlaySequence (String s) {
    String[] times = s.split(" ");
    for(int i = 0; i < times.length; i++) {
      String[] notes = times[i].split(",");
      playSeq.add(notes);    
    }
    
    lastPlayedTime = System.currentTimeMillis();
    playingSequence = true;
  }

  void OnKeyPressed(char k) {
    if(playingSequence) return;
    
    if(k == '1') {
      instrument.SetPitch(Frequency.ofPitch("C3").asHz());
      PlayNote();
    } else if(k == '2') {
      instrument.SetPitch(Frequency.ofPitch("D3").asHz());
      PlayNote();
    } else if(k == '3') {
      instrument.SetPitch(Frequency.ofPitch("E3").asHz());
      PlayNote();
    } else if(k == '4') {
      instrument.SetPitch(Frequency.ofPitch("F3").asHz());
      PlayNote();
    } else if(k == '5') {
      instrument.SetPitch(Frequency.ofPitch("G3").asHz());
      PlayNote();
    } else if(k == '6') {
      instrument.SetPitch(Frequency.ofPitch("A3").asHz());
      PlayNote();
    } else if(k == '7') {
      instrument.SetPitch(Frequency.ofPitch("B3").asHz());
      PlayNote();
    } else if(k == '8') {
      instrument.SetPitch(Frequency.ofPitch("C4").asHz());
      PlayNote();
    } else if(k == ' ') {
      instrument.Reset(); 
    }
  }
  
  private void PlayNote() {
    out.playNote(0.0, (60.0 / tempo) / 4.0, instrument);
  }

  public void Update() {
    background(0);
    stroke(255);

    int leftOffset = 50;
    int rightOffset = 100;
    int amplitude = 50;

    for (int i = 0; i < out.bufferSize() - 1; i++) {
      float left1 = leftOffset + out.left.get(i) * amplitude;
      float left2 = leftOffset + out.left.get(i + 1) * amplitude;
      float right1 = rightOffset + out.right.get(i) * amplitude;
      float right2 = rightOffset + out.right.get(i + 1) * amplitude;
      line(i, left1, i+1, left2);
      line(i, right1, i+1, right2);
    }
    
    if(playingSequence) {
      if(System.currentTimeMillis() - lastPlayedTime >= 250) {
        if(playSeq.peek() == null) {
          playingSequence = false; 
          return;
        }
        
        String[] notes = playSeq.remove();
        
        for(int i = 0; i < notes.length; i++) {
          if(notes[i].equals("-")) {
            continue; 
          }
          
          instrument.SetPitch(Frequency.ofPitch(notes[i]).asHz());
          PlayNote(); 
        }
        
        lastPlayedTime = System.currentTimeMillis();
      }
    }
  }
}

public class MyInstrument implements Instrument {
  Oscil wave1;
  Oscil wave2;
  Line amp;
  
  private ArrayList<MyNote> curNotes = new ArrayList<MyNote>();
  private AudioOutput out;
  private Queue<Float> queuedPitches = new LinkedList<Float>();
  
  public MyInstrument(AudioOutput out) {
    this.out = out;
  }
  
  public void SetPitch(float freq) {
    queuedPitches.add(freq);
  }
  
  public void Reset() {
    curNotes = new ArrayList<MyNote>();
  }
  
  void noteOn(float duration) {
    while(queuedPitches.peek() != null) {
      curNotes.add(new MyNote(queuedPitches.remove(), duration, out));
    }
  }
  
  void noteOff() {
    curNotes.get(0).Destruct(out);
    curNotes.remove(0);
  }
}

public class MyNote {  
  Oscil wave;
  Oscil wave2;
  Oscil wave3;
  Line amp;
  Line amp2;
  Line amp3;
  
  public MyNote(float freq, float duration, AudioOutput out) {
    wave = new Oscil(freq, 0, Waves.SINE);
    wave2 = new Oscil(freq, 0, Waves.SAW);
    wave3 = new Oscil(freq * 2, 0, Waves.TRIANGLE);
    
    amp = new Line();
    amp2 = new Line();
    amp3 = new Line();
    
    amp.patch(wave.amplitude);
    amp2.patch(wave2.amplitude);
    amp3.patch(wave3.amplitude);
    
    wave.patch(out);
    wave2.patch(out);
    wave3.patch(out);
    
    amp.activate(duration, 0.5f, 0f);
    amp2.activate(duration / 5, 0.2f, 0f);
    amp3.activate(duration / 1.5, 0.5f, 0f);
  }
  
  public void Destruct(AudioOutput out) {
    wave.unpatch(out);
    wave2.unpatch(out);
    wave3.unpatch(out);
    
    amp = null;
    amp2 = null;
    amp3 = null;
    
    wave = null;
    wave2 = null;
    wave3 = null;
  }
}
