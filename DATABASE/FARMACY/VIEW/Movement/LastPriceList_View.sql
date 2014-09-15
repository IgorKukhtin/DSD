-- View: Object_Unit_View

DROP VIEW IF EXISTS LastPriceList_View;

CREATE OR REPLACE VIEW LastPriceList_View AS 
       SELECT Movement.Id AS MovementId, MovementLinkObject_Juridical.ObjectId AS JuridicalId
  FROM Movement
         JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                 ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
      JOIN (SELECT max(Movement.OperDate) AS OperDate, MovementLinkObject_Juridical.ObjectId FROM Movement
            JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                    ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                   AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
           WHERE Movement.DescId = zc_Movement_PriceList()
       GROUP BY MovementLinkObject_Juridical.ObjectId) AS MaxMovement ON MaxMovement.OperDate = Movement.OperDate
                         AND MaxMovement.ObjectId = MovementLinkObject_Juridical.ObjectId

     WHERE Movement.DescId = zc_Movement_PriceList() ;

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
