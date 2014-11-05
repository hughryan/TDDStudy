import org.junit.*;
import static org.junit.Assert.*;

public class UntitledTest {
    
    @Test
    public void hitch_hiker() {
        
        Calcul tester = new Calcul();        

        assertEquals("Un seul livre doit couter 8.00", 8.00, tester.calculPrix(0,0,0,1,0), 0.01);
        assertEquals("Deux exemplaires d'un meme tome doivent couter 16.00", 16.00, tester.calculPrix(0,0,0,2,0), 0.01);
        assertEquals("Deux tomes differents doivent couter 15.20", 15.2, tester.calculPrix(0,1,0,1,0), 0.01);
        assertEquals("Un exemplaire d'un tome et deux exemplaires d'un autre tome doivent couter 23.20", 23.20, tester.calculPrix(0,1,0,2,0), 0.01);
        assertEquals("Trois tomes differents doivent couter 21.60", 21.60, tester.calculPrix(0,1,1,1,0), 0.01);
        assertEquals("Deux exemplaires d'un tome et un exemplaire de deux autres tomes doivent couter 29.60", 29.60, tester.calculPrix(0,1,1,2,0), 0.01);
        assertEquals("Quatre tomes differents doivent couter 25.60", 25.60, tester.calculPrix(0,1,1,1,1), 0.01);
        assertEquals("Quatre tomes differents doivent couter 40.80", 40.80, tester.calculPrix(0,1,2,1,2), 0.01);
        assertEquals("Cinq tomes différents doivent couter 30.00", 30.00, tester.calculPrix(1,1,1,1,1), 0.01);
        assertEquals("Cinq tomes différents doivent couter 51.20", 51.20, tester.calculPrix(2,2,2,1,1), 0.01);
    }
}