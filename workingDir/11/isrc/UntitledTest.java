import org.junit.*;
import static org.junit.Assert.*;

public class UntitledTest {
  static {
    CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h.ping();
  }

    
    @Test
    public void hitch_hiker() {
        
        CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h.statements[1]++;
Calcul tester = new Calcul();        

        CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h.statements[2]++;
assertEquals("Un seul livre doit couter 8.00", 8.00, tester.calculPrix(0,0,0,1,0), 0.01);
        CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h.statements[3]++;
assertEquals("Deux exemplaires d'un meme tome doivent couter 16.00", 16.00, tester.calculPrix(0,0,0,2,0), 0.01);
        CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h.statements[4]++;
assertEquals("Deux tomes differents doivent couter 15.20", 15.2, tester.calculPrix(0,1,0,1,0), 0.01);
        CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h.statements[5]++;
assertEquals("Un exemplaire d'un tome et deux exemplaires d'un autre tome doivent couter 23.20", 23.20, tester.calculPrix(0,1,0,2,0), 0.01);
        CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h.statements[6]++;
assertEquals("Trois tomes differents doivent couter 21.60", 21.60, tester.calculPrix(0,1,1,1,0), 0.01);
        CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h.statements[7]++;
assertEquals("Deux exemplaires d'un tome et un exemplaire de deux autres tomes doivent couter 29.60", 29.60, tester.calculPrix(0,1,1,2,0), 0.01);
        CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h.statements[8]++;
assertEquals("Quatre tomes differents doivent couter 25.60", 25.60, tester.calculPrix(0,1,1,1,1), 0.01);
        CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h.statements[9]++;
assertEquals("Quatre tomes differents doivent couter 40.80", 40.80, tester.calculPrix(0,1,2,1,2), 0.01);
        CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h.statements[10]++;
assertEquals("Cinq tomes différents doivent couter 30.00", 30.00, tester.calculPrix(1,1,1,1,1), 0.01);
        CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h.statements[11]++;
assertEquals("Cinq tomes différents doivent couter 51.20", 51.20, tester.calculPrix(2,2,2,1,1), 0.01);
    }
}

class CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h extends org.codecover.instrumentation.java.measurement.CounterContainer {

  static {
    org.codecover.instrumentation.java.measurement.ProtocolImpl.getInstance(org.codecover.instrumentation.java.measurement.CoverageResultLogFile.getInstance(null), "bed88120-5ad6-4f91-93b0-dd07de17c159").addObservedContainer(new CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h ());
  }
    public static long[] statements = new long[12];
    public static long[] branches = new long[0];
    public static long[] loops = new long[1];

  public CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h () {
    super("UntitledTest.java");
  }

  public static void ping() {/* nothing to do*/}

  public void reset() {
      for (int i = 1; i <= 11; i++) {
        statements[i] = 0L;
      }
      for (int i = 1; i <= -1; i++) {
        branches[i] = 0L;
      }
      for (int i = 1; i <= 0; i++) {
        loops[i] = 0L;
      }
  }

  public void serializeAndReset(org.codecover.instrumentation.measurement.CoverageCounterLog log) {
    log.startNamedSection("UntitledTest.java");
      for (int i = 1; i <= 11; i++) {
        if (statements[i] != 0L) {
          log.passCounter("S" + i, statements[i]);
          statements[i] = 0L;
        }
      }
      for (int i = 1; i <= -1; i++) {
        if (branches[i] != 0L) {
          log.passCounter("B"+ i, branches[i]);
          branches[i] = 0L;
        }
      }
      for (int i = 1; i <= 0; i++) {
        if (loops[i * 3 - 2] != 0L) {
          log.passCounter("L" + i + "-0", loops[i * 3 - 2]);
          loops[i * 3 - 2] = 0L;
        }
        if ( loops[i * 3 - 1] != 0L) {
          log.passCounter("L" + i + "-1", loops[i * 3 - 1]);
          loops[i * 3 - 1] = 0L;
        }
        if ( loops[i * 3] != 0L) {
          log.passCounter("L" + i + "-2", loops[i * 3]);
          loops[i * 3] = 0L;
        }
      }
  }
}
