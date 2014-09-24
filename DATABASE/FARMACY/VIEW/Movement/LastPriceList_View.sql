-- View: Object_Unit_View

DROP VIEW IF EXISTS LastPriceList_View;

CREATE OR REPLACE VIEW LastPriceList_View AS 
SELECT JuridicalId, ContractId, MovementId 
  FROM (SELECT max(Movement.OperDate) OVER (PARTITION BY MovementLinkObject_Juridical.ObjectId, COALESCE(MovementLinkObject_Contract.ObjectId, 0)) AS Max_Date
     , Movement.OperDate, Movement.Id AS MovementId, MovementLinkObject_Juridical.ObjectId AS JuridicalId 
     , COALESCE(MovementLinkObject_Contract.ObjectId, 0) AS ContractId
       FROM Movement
       LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                    ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                   AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()

       LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                    ON MovementLinkObject_Contract.MovementId = Movement.Id
                                   AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

           WHERE Movement.DescId = zc_Movement_PriceList()) AS PriceList
           WHERE PriceList.Max_Date = PriceList.OperDate;

ALTER TABLE LastPriceList_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.09.14                        * 
*/

-- тест
-- SELECT * FROM LastPriceList_View
