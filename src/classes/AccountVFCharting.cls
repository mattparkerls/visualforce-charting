public with sharing class AccountVFCharting {

	public Account a {get; set;}
	public boolean render {get; set;}
	public Integer currentYear = date.Today().year();
	public Date last12Months = date.Today().addMonths(-12);
	public Integer totalRevenue {get; set;}

		
	//Grabbing the Accountid from the current record//
	public AccountVFCharting(ApexPages.StandardController controller) {
			
		render=true;
	
		try{
        a = [SELECT Id, Name, Site, owner.name, phone,billingstreet,billingstate,billingcountry,billingcity FROM Account 
                   WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
		}
		catch(Exception ex1){
			System.Debug('We did not find the Account' + ex1);
		}
                 
      	AggregateResult renderCheck = [select Count(id) numOpps, SUM(Amount) totalRev from Opportunity where Accountid = :a.id
      	 AND CALENDAR_YEAR(CloseDate) = :currentYear];
      	 
      	//checking if there are any related Opps, and aggregating their revenue
      	 System.Debug('Number of Opps returned in query is ' + Integer.valueOf(renderCheck.get('numOpps')));
			if(Integer.valueOf(renderCheck.get('numOpps')) > 0){
				render=true;
				totalRevenue = Integer.valueOf(renderCheck.get('totalRev'));
			}       
        
	}	
    	
	//-----------------Stacked CHART CONTROLLER---------------//	
public List<AggregateResult> getBarSeriesData() {
			
       AggregateResult[] OppStatusAmounts = [SELECT SUM(Amount) amountRev, SUM(Amount) claimRev,
        SUM(Amount) approvedRev, SUM(Amount) funds, StageName, COUNT(Id) Opps
             FROM Opportunity
             WHERE Accountid = :a.id
             AND CALENDAR_YEAR(CloseDate) = :currentYear
             GROUP BY StageName];
             
       return OppStatusAmounts;       
    }
            		
	//-----------------LINE CHART CONTROLLER----------------//	
public List<AggregateResult> getLineData() {
        return
            [SELECT SUM(Amount) monthlyRevenue, COUNT(Name) numOppsClosedWon,
                  CALENDAR_MONTH(CloseDate) theMonth
             FROM Opportunity
             WHERE Accountid = :a.id AND CALENDAR_YEAR(CloseDate) = :currentYear
             GROUP BY CALENDAR_MONTH(CloseDate)
             ORDER BY CALENDAR_MONTH(CloseDate)];
    }
    
    //--------------GAUGE CHART Controller---------------//
    public List<gaugeData> getData() {
    	  Integer TotalOpptys = 0;
    	  Integer TotalAmount = 0;
          Integer thisMonth = date.Today().month();

          AggregateResult ClosedWonOpptys = [select SUM(Amount) totalRevenue, CALENDAR_YEAR(CloseDate) theYear, COUNT(Name) numOpps
                                   from Opportunity
                                  where AccountId =: a.id
                                   and StageName = 'Closed Won' 
                                   and CALENDAR_YEAR(CloseDate) = :currentYear 
                                   GROUP BY CALENDAR_YEAR(CloseDate) LIMIT 1];
            					
          List<gaugeData> data = new List<gaugeData>();
          data.add(new gaugeData(Integer.valueOf(ClosedWonOpptys.get('numOpps')) + ' Deals', Integer.valueOf(ClosedWonOpptys.get('totalRevenue'))));
          		
          return data; 
                   			                  
     }

    public class gaugeData {
        public String name { get; set; }
        public Integer size { get; set; }

        public gaugeData(String name, Integer data) {
            this.name = name;
            this.size = data;
        }
    }	  
}