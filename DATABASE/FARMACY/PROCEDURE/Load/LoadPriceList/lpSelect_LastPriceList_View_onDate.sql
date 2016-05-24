-- Function: lpSelect_LastPriceList_View_onDate()

DROP FUNCTION IF EXISTS lpSelect_LastPriceList_View_onDate (TDateTime , Integer);

CREATE OR REPLACE FUNCTION lpSelect_LastPriceList_View_onDate(
    IN inOperDate    TDateTime       , -- ключ Документа
    IN inUserId      Integer        -- сессия пользователя
)

RETURNS TABLE (
    JuridicalId         integer,
    ContractId          integer,
    MovementId          integer
)

AS
$BODY$
BEGIN

  RETURN QUERY
  SELECT PriceList.JuridicalId, PriceList.ContractId, PriceList.MovementId 
  FROM (SELECT max (Movement.OperDate) OVER (PARTITION BY MovementLinkObject_Juridical.ObjectId, COALESCE (MovementLinkObject_Contract.ObjectId, 0)) AS Max_Date
             , Movement.OperDate
             , Movement.Id AS MovementId
             , MovementLinkObject_Juridical.ObjectId AS JuridicalId 
             , COALESCE(MovementLinkObject_Contract.ObjectId, 0) AS ContractId
       FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
       WHERE Movement.DescId = zc_Movement_PriceList()
         AND Movement.OperDate <= inOperDate
      ) AS PriceList
  WHERE PriceList.Max_Date = PriceList.OperDate;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 20.05.16                                        *
*/
-- SELECT * FROM lpSelect_LastPriceList_View_onDate (CURRENT_DATE - INTERVAL '3 DAY', 3)
