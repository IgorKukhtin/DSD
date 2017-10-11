-- Function: lpSelect_LastPriceList_View_onDate()

DROP FUNCTION IF EXISTS lpSelect_LastPriceList_View_onDate (TDateTime, Integer);
DROP FUNCTION IF EXISTS lpSelect_LastPriceList_View_onDate (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelect_LastPriceList_View_onDate(
    IN inOperDate    TDateTime, -- ключ Документа
    IN inUnitId      Integer  ,
    IN inUserId      Integer    -- сессия пользователя
)

RETURNS TABLE (
    JuridicalId         integer,
    ContractId          integer,
    AreaId              integer,
    MovementId          integer
)

AS
$BODY$
BEGIN

  RETURN QUERY
  WITH
  tmpJuridicalArea AS (SELECT DISTINCT 
                              tmp.JuridicalId              AS JuridicalId
                            , tmp.AreaId_Juridical         AS AreaId
                       FROM lpSelect_Object_JuridicalArea_byUnit (inUnitId, 0) AS tmp
                       )
                       
  SELECT PriceList.JuridicalId
       , PriceList.ContractId
       , PriceList.AreaId
       , PriceList.MovementId 
  FROM (SELECT max (Movement.OperDate) OVER (PARTITION BY MovementLinkObject_Juridical.ObjectId, COALESCE (MovementLinkObject_Contract.ObjectId, 0)) AS Max_Date
             , Movement.OperDate                                 AS OperDate
             , Movement.Id                                       AS MovementId
             , MovementLinkObject_Juridical.ObjectId             AS JuridicalId 
             , COALESCE(MovementLinkObject_Contract.ObjectId, 0) AS ContractId
             , COALESCE(MovementLinkObject_Area.ObjectId, 0)     AS AreaId
             
       FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                         ON MovementLinkObject_Area.MovementId = Movement.Id
                                        AND MovementLinkObject_Area.DescId = zc_MovementLinkObject_Area()                             
            
            JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = MovementLinkObject_Juridical.ObjectId
                                 AND tmpJuridicalArea.AreaId      = MovementLinkObject_Area.ObjectId 
                                 
       WHERE Movement.DescId = zc_Movement_PriceList()
         AND Movement.OperDate <= inOperDate
         AND Movement.StatusId <> zc_Enum_Status_Erased()
      ) AS PriceList
  WHERE PriceList.Max_Date = PriceList.OperDate;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 11.10.17         * 
 20.05.16                                        *
*/
-- SELECT * FROM lpSelect_LastPriceList_View_onDate (CURRENT_DATE - INTERVAL '3 DAY', 0, 3)
