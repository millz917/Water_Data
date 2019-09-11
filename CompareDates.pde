import java.util.Date; //libraries to load
import java.util.Calendar;
import java.time.temporal.ChronoUnit;
import java.util.GregorianCalendar;

/*THIS ENTIRE CLASS IS REFERENCED FROM THE DATAMODEL*/ 
class CompareDates
{
  /* This class makes use of several Java libraries to allow calculation of differences between dates 
   METHODS:
   public int betweenDates(Date firstDate, Date secondDate) 
   public int betweenDates(String date1, String date2) 
   public int yearsBetweenDates(String date1, String date2) 
   */

  protected Calendar calendar;

  public int betweenDates(Date firstDate, Date secondDate) {
    /* returns number of days between two dates provided in a date format */
    return (int)ChronoUnit.DAYS.between(firstDate.toInstant(), secondDate.toInstant());
  }

  public int betweenDates(String date1, String date2) {
    /* returns number of days between two dates provided in a string format */
    int[] d_1 = int(splitTokens(date1, "/"));//split string into [0]dd/[1]mm/[2]yyyy pieces
    int[] d_2 = int(splitTokens(date2, "/"));
    Date a = new GregorianCalendar(d_1[2], d_1[1]-1, d_1[0]).getTime(); //format DataManager as Java Date object
    Date b = new GregorianCalendar(d_2[2], d_2[1]-1, d_2[0]).getTime();
    return (int)ChronoUnit.DAYS.between(a.toInstant(), b.toInstant());
  }

  public int yearsBetweenDates(String date1, String date2) {
    /* returns number of years between two given dates
     for more detail see https://docs.oracle.com/javase/8/docs/api/java/time/temporal/ChronoUnit.html
     */
    int days = betweenDates(date1, date2);
    return int(days/365.2425);
  }
}
