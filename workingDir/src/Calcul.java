
public class Calcul {
    
    public double calculPrix(int qteTome1, int qteTome2, int qteTome3, int qteTome4, int qteTome5) {
        double prix = 0;
        int tableau[] = {qteTome1, qteTome2, qteTome3, qteTome4, qteTome5};
        int tableauReducs[] = {0,0,0,0,0};

        while(this.checkNbTomeDiff(tableau) != 0){

           if (this.checkNbTomeDiff(tableau) == 1){
               prix = prix + 8;
               this.supprimerTomeListe(tableau);
               tableauReducs[0]++;
    	   }
	   else if (this.checkNbTomeDiff(tableau) == 2){					// Cas ou il y a deux tomes de présent (quantité variable).
	       prix = prix + (16-0.05*16);
	       this.supprimerTomeListe(tableau);
               tableauReducs[1]++;
	   }
	   else if (this.checkNbTomeDiff(tableau) == 3){
	       prix = prix + (24-0.1*24);
	       this.supprimerTomeListe(tableau);
               tableauReducs[2]++;
	   }
	   else if (this.checkNbTomeDiff(tableau) == 4){
	       prix = prix + (32-0.2*32);
	       this.supprimerTomeListe(tableau);
               tableauReducs[3]++;
	   }
	   else if (this.checkNbTomeDiff(tableau) == 5){
               prix = prix + (40-0.25*40);
	       this.supprimerTomeListe(tableau);
               tableauReducs[4]++;
	   }
        }
        prix = prix - 0.4*this.checkEconomies(tableauReducs);
        return prix;
    }

    public int checkNbTomeDiff(int tab[]) {
	int cpt = 0;
	for (int j = 0; j < 5; j++) {
		if (tab[j] != 0) {
		    cpt++;
		}
	}
	return cpt;
    }

    public int[] supprimerTomeListe(int[] tab) {
	for (int j = 0; j < 5; j++) {
            if (tab[j] != 0) {
                tab[j]--;
	    }
	}
	return tab;
    }

    public int checkEconomies(int[] tab) {
	if (tab[2] != 0 && tab[4] != 0){
	    if (tab[2] > tab[4]){
		return tab[2];
	    }
	    else return tab[4];
	}
	return 0;		
    }

}