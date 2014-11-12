
public class Calcul {
  static {
    CodeCoverCoverageCounter$a8gr7irlznadko4td.ping();
  }

    
    public double calculPrix(int qteTome1, int qteTome2, int qteTome3, int qteTome4, int qteTome5) {
        CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[1]++;
double prix = 0;
        CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[2]++;
int tableau[] = {qteTome1, qteTome2, qteTome3, qteTome4, qteTome5};
        CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[3]++;
int tableauReducs[] = {0,0,0,0,0};
byte CodeCoverLoopChoiceHelper_L1 = 0;


int CodeCoverConditionCoverageHelper_C1;

        CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[4]++;
CodeCoverCoverageCounter$a8gr7irlznadko4td.loops[1]++;
while((((((CodeCoverConditionCoverageHelper_C1 = 0) == 0) || true) && (
(((CodeCoverConditionCoverageHelper_C1 |= (2)) == 0 || true) &&
 ((this.checkNbTomeDiff(tableau) != 0) && 
  ((CodeCoverConditionCoverageHelper_C1 |= (1)) == 0 || true)))
)) && (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[1].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C1, 1) || true)) || (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[1].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C1, 1) && false)){
if (CodeCoverLoopChoiceHelper_L1 == 0) {
  CodeCoverLoopChoiceHelper_L1++;
  CodeCoverCoverageCounter$a8gr7irlznadko4td.loops[1]--;
  CodeCoverCoverageCounter$a8gr7irlznadko4td.loops[2]++;
} else if (CodeCoverLoopChoiceHelper_L1 == 1) {
  CodeCoverLoopChoiceHelper_L1++;
  CodeCoverCoverageCounter$a8gr7irlznadko4td.loops[2]--;
  CodeCoverCoverageCounter$a8gr7irlznadko4td.loops[3]++;
}
int CodeCoverConditionCoverageHelper_C2;

           CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[5]++;
if ((((((CodeCoverConditionCoverageHelper_C2 = 0) == 0) || true) && (
(((CodeCoverConditionCoverageHelper_C2 |= (2)) == 0 || true) &&
 ((this.checkNbTomeDiff(tableau) == 1) && 
  ((CodeCoverConditionCoverageHelper_C2 |= (1)) == 0 || true)))
)) && (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[2].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C2, 1) || true)) || (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[2].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C2, 1) && false)){
CodeCoverCoverageCounter$a8gr7irlznadko4td.branches[1]++;
               CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[6]++;
prix = prix + 8;
               CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[7]++;
this.supprimerTomeListe(tableau);
               CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[8]++;
tableauReducs[0]++;

    	   }
	   else {
CodeCoverCoverageCounter$a8gr7irlznadko4td.branches[2]++;
int CodeCoverConditionCoverageHelper_C3; CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[9]++;
if ((((((CodeCoverConditionCoverageHelper_C3 = 0) == 0) || true) && (
(((CodeCoverConditionCoverageHelper_C3 |= (2)) == 0 || true) &&
 ((this.checkNbTomeDiff(tableau) == 2) && 
  ((CodeCoverConditionCoverageHelper_C3 |= (1)) == 0 || true)))
)) && (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[3].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C3, 1) || true)) || (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[3].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C3, 1) && false)){
CodeCoverCoverageCounter$a8gr7irlznadko4td.branches[3]++;					// Cas ou il y a deux tomes de présent (quantité variable).
	       CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[10]++;
prix = prix + (16-0.05*16);
	       CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[11]++;
this.supprimerTomeListe(tableau);
               CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[12]++;
tableauReducs[1]++;

	   }
	   else {
CodeCoverCoverageCounter$a8gr7irlznadko4td.branches[4]++;
int CodeCoverConditionCoverageHelper_C4; CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[13]++;
if ((((((CodeCoverConditionCoverageHelper_C4 = 0) == 0) || true) && (
(((CodeCoverConditionCoverageHelper_C4 |= (2)) == 0 || true) &&
 ((this.checkNbTomeDiff(tableau) == 3) && 
  ((CodeCoverConditionCoverageHelper_C4 |= (1)) == 0 || true)))
)) && (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[4].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C4, 1) || true)) || (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[4].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C4, 1) && false)){
CodeCoverCoverageCounter$a8gr7irlznadko4td.branches[5]++;
	       CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[14]++;
prix = prix + (24-0.1*24);
	       CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[15]++;
this.supprimerTomeListe(tableau);
               CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[16]++;
tableauReducs[2]++;

	   }
	   else {
CodeCoverCoverageCounter$a8gr7irlznadko4td.branches[6]++;
int CodeCoverConditionCoverageHelper_C5; CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[17]++;
if ((((((CodeCoverConditionCoverageHelper_C5 = 0) == 0) || true) && (
(((CodeCoverConditionCoverageHelper_C5 |= (2)) == 0 || true) &&
 ((this.checkNbTomeDiff(tableau) == 4) && 
  ((CodeCoverConditionCoverageHelper_C5 |= (1)) == 0 || true)))
)) && (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[5].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C5, 1) || true)) || (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[5].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C5, 1) && false)){
CodeCoverCoverageCounter$a8gr7irlznadko4td.branches[7]++;
	       CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[18]++;
prix = prix + (32-0.2*32);
	       CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[19]++;
this.supprimerTomeListe(tableau);
               CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[20]++;
tableauReducs[3]++;

	   }
	   else {
CodeCoverCoverageCounter$a8gr7irlznadko4td.branches[8]++;
int CodeCoverConditionCoverageHelper_C6; CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[21]++;
if ((((((CodeCoverConditionCoverageHelper_C6 = 0) == 0) || true) && (
(((CodeCoverConditionCoverageHelper_C6 |= (2)) == 0 || true) &&
 ((this.checkNbTomeDiff(tableau) == 5) && 
  ((CodeCoverConditionCoverageHelper_C6 |= (1)) == 0 || true)))
)) && (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[6].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C6, 1) || true)) || (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[6].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C6, 1) && false)){
CodeCoverCoverageCounter$a8gr7irlznadko4td.branches[9]++;
               CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[22]++;
prix = prix + (40-0.25*40);
	       CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[23]++;
this.supprimerTomeListe(tableau);
               CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[24]++;
tableauReducs[4]++;

	   } else {
  CodeCoverCoverageCounter$a8gr7irlznadko4td.branches[10]++;}
}
}
}
}
        }
        CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[25]++;
prix = prix - 0.4*this.checkEconomies(tableauReducs);
        CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[26]++;
return prix;
    }

    public int checkNbTomeDiff(int tab[]) {
	CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[27]++;
int cpt = 0;
byte CodeCoverLoopChoiceHelper_L2 = 0;


int CodeCoverConditionCoverageHelper_C7;
	CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[28]++;
CodeCoverCoverageCounter$a8gr7irlznadko4td.loops[4]++;
for (int j = 0;(((((CodeCoverConditionCoverageHelper_C7 = 0) == 0) || true) && (
(((CodeCoverConditionCoverageHelper_C7 |= (2)) == 0 || true) &&
 ((j < 5) && 
  ((CodeCoverConditionCoverageHelper_C7 |= (1)) == 0 || true)))
)) && (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[7].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C7, 1) || true)) || (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[7].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C7, 1) && false); j++) {
if (CodeCoverLoopChoiceHelper_L2 == 0) {
  CodeCoverLoopChoiceHelper_L2++;
  CodeCoverCoverageCounter$a8gr7irlznadko4td.loops[4]--;
  CodeCoverCoverageCounter$a8gr7irlznadko4td.loops[5]++;
} else if (CodeCoverLoopChoiceHelper_L2 == 1) {
  CodeCoverLoopChoiceHelper_L2++;
  CodeCoverCoverageCounter$a8gr7irlznadko4td.loops[5]--;
  CodeCoverCoverageCounter$a8gr7irlznadko4td.loops[6]++;
}
int CodeCoverConditionCoverageHelper_C8;
		CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[29]++;
if ((((((CodeCoverConditionCoverageHelper_C8 = 0) == 0) || true) && (
(((CodeCoverConditionCoverageHelper_C8 |= (2)) == 0 || true) &&
 ((tab[j] != 0) && 
  ((CodeCoverConditionCoverageHelper_C8 |= (1)) == 0 || true)))
)) && (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[8].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C8, 1) || true)) || (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[8].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C8, 1) && false)) {
CodeCoverCoverageCounter$a8gr7irlznadko4td.branches[11]++;
		    CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[30]++;
cpt++;

		} else {
  CodeCoverCoverageCounter$a8gr7irlznadko4td.branches[12]++;}
	}
	CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[31]++;
return cpt;
    }

    public int[] supprimerTomeListe(int[] tab) {
byte CodeCoverLoopChoiceHelper_L3 = 0;


int CodeCoverConditionCoverageHelper_C9;
	CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[32]++;
CodeCoverCoverageCounter$a8gr7irlznadko4td.loops[7]++;
for (int j = 0;(((((CodeCoverConditionCoverageHelper_C9 = 0) == 0) || true) && (
(((CodeCoverConditionCoverageHelper_C9 |= (2)) == 0 || true) &&
 ((j < 5) && 
  ((CodeCoverConditionCoverageHelper_C9 |= (1)) == 0 || true)))
)) && (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[9].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C9, 1) || true)) || (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[9].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C9, 1) && false); j++) {
if (CodeCoverLoopChoiceHelper_L3 == 0) {
  CodeCoverLoopChoiceHelper_L3++;
  CodeCoverCoverageCounter$a8gr7irlznadko4td.loops[7]--;
  CodeCoverCoverageCounter$a8gr7irlznadko4td.loops[8]++;
} else if (CodeCoverLoopChoiceHelper_L3 == 1) {
  CodeCoverLoopChoiceHelper_L3++;
  CodeCoverCoverageCounter$a8gr7irlznadko4td.loops[8]--;
  CodeCoverCoverageCounter$a8gr7irlznadko4td.loops[9]++;
}
int CodeCoverConditionCoverageHelper_C10;
            CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[33]++;
if ((((((CodeCoverConditionCoverageHelper_C10 = 0) == 0) || true) && (
(((CodeCoverConditionCoverageHelper_C10 |= (2)) == 0 || true) &&
 ((tab[j] != 0) && 
  ((CodeCoverConditionCoverageHelper_C10 |= (1)) == 0 || true)))
)) && (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[10].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C10, 1) || true)) || (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[10].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C10, 1) && false)) {
CodeCoverCoverageCounter$a8gr7irlznadko4td.branches[13]++;
                CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[34]++;
tab[j]--;

	    } else {
  CodeCoverCoverageCounter$a8gr7irlznadko4td.branches[14]++;}
	}
	CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[35]++;
return tab;
    }

    public int checkEconomies(int[] tab) {
int CodeCoverConditionCoverageHelper_C11;
	CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[36]++;
if ((((((CodeCoverConditionCoverageHelper_C11 = 0) == 0) || true) && (
(((CodeCoverConditionCoverageHelper_C11 |= (8)) == 0 || true) &&
 ((tab[2] != 0) && 
  ((CodeCoverConditionCoverageHelper_C11 |= (4)) == 0 || true)))
 && 
(((CodeCoverConditionCoverageHelper_C11 |= (2)) == 0 || true) &&
 ((tab[4] != 0) && 
  ((CodeCoverConditionCoverageHelper_C11 |= (1)) == 0 || true)))
)) && (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[11].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C11, 2) || true)) || (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[11].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C11, 2) && false)){
CodeCoverCoverageCounter$a8gr7irlznadko4td.branches[15]++;
int CodeCoverConditionCoverageHelper_C12;
	    CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[37]++;
if ((((((CodeCoverConditionCoverageHelper_C12 = 0) == 0) || true) && (
(((CodeCoverConditionCoverageHelper_C12 |= (2)) == 0 || true) &&
 ((tab[2] > tab[4]) && 
  ((CodeCoverConditionCoverageHelper_C12 |= (1)) == 0 || true)))
)) && (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[12].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C12, 1) || true)) || (CodeCoverCoverageCounter$a8gr7irlznadko4td.conditionCounters[12].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C12, 1) && false)){
CodeCoverCoverageCounter$a8gr7irlznadko4td.branches[17]++;
		CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[38]++;
return tab[2];

	    }
	    else {
CodeCoverCoverageCounter$a8gr7irlznadko4td.branches[18]++; CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[39]++;
return tab[4];
}

	} else {
  CodeCoverCoverageCounter$a8gr7irlznadko4td.branches[16]++;}
	CodeCoverCoverageCounter$a8gr7irlznadko4td.statements[40]++;
return 0;		
    }

}

class CodeCoverCoverageCounter$a8gr7irlznadko4td extends org.codecover.instrumentation.java.measurement.CounterContainer {

  static {
    org.codecover.instrumentation.java.measurement.ProtocolImpl.getInstance(org.codecover.instrumentation.java.measurement.CoverageResultLogFile.getInstance(null), "bed88120-5ad6-4f91-93b0-dd07de17c159").addObservedContainer(new CodeCoverCoverageCounter$a8gr7irlznadko4td ());
  }
    public static long[] statements = new long[41];
    public static long[] branches = new long[19];

  public static final org.codecover.instrumentation.java.measurement.ConditionCounter[] conditionCounters = new org.codecover.instrumentation.java.measurement.ConditionCounter[13];
  static {
    final String SECTION_NAME = "Calcul.java";
    final byte[] CONDITION_COUNTER_TYPES = {0,1,1,1,1,1,1,1,1,1,1,2,1};
    for (int i = 1; i <= 12; i++) {
      switch (CONDITION_COUNTER_TYPES[i]) {
        case 0 : break;
        case 1 : conditionCounters[i] = new org.codecover.instrumentation.java.measurement.SmallOneConditionCounter(SECTION_NAME, "C" + i); break;
        case 2 : conditionCounters[i] = new org.codecover.instrumentation.java.measurement.SmallTwoConditionCounter(SECTION_NAME, "C" + i); break;
        case 3 : conditionCounters[i] = new org.codecover.instrumentation.java.measurement.MediumConditionCounter(SECTION_NAME, "C" + i); break;
        case 4 : conditionCounters[i] = new org.codecover.instrumentation.java.measurement.LargeConditionCounter(SECTION_NAME, "C" + i); break;
      }
    }
  }
    public static long[] loops = new long[10];

  public CodeCoverCoverageCounter$a8gr7irlznadko4td () {
    super("Calcul.java");
  }

  public static void ping() {/* nothing to do*/}

  public void reset() {
      for (int i = 1; i <= 40; i++) {
        statements[i] = 0L;
      }
      for (int i = 1; i <= 18; i++) {
        branches[i] = 0L;
      }
    for (int i = 1; i <= 12; i++) {
      if (conditionCounters[i] != null) {
        conditionCounters[i].reset();
      }
    }
      for (int i = 1; i <= 9; i++) {
        loops[i] = 0L;
      }
  }

  public void serializeAndReset(org.codecover.instrumentation.measurement.CoverageCounterLog log) {
    log.startNamedSection("Calcul.java");
      for (int i = 1; i <= 40; i++) {
        if (statements[i] != 0L) {
          log.passCounter("S" + i, statements[i]);
          statements[i] = 0L;
        }
      }
      for (int i = 1; i <= 18; i++) {
        if (branches[i] != 0L) {
          log.passCounter("B"+ i, branches[i]);
          branches[i] = 0L;
        }
      }
    for (int i = 1; i <= 12; i++) {
      if (conditionCounters[i] != null) {
        conditionCounters[i].serializeAndReset(log);
      }
    }
      for (int i = 1; i <= 3; i++) {
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
