 -- Function: gpSelect_AsinoPharmaSP_Cash()

DROP FUNCTION IF EXISTS gpSelect_AsinoPharmaSP_Cash (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_AsinoPharmaSP_Cash(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id                Integer
             , MIId              Integer
             , Queue             Integer
             , OperDateEnd       TDateTime
             , ChildIdList       TVarChar
             , ChildAmountList   TVarChar
             , SecondIdList      TVarChar
             , SecondAmountList  TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());
    
    RETURN QUERY
    WITH
         -- Товары соц-проект
           tmpMovement AS (SELECT Movement.Id
                                , Movement.OperDate
                                , MovementDate_OperDateEnd.ValueData  AS OperDateEnd
                           FROM Movement

                                INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                        ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                       AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                                       AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE

                                INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                        ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                       AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                                       AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE

                           WHERE Movement.DescId = zc_Movement_AsinoPharmaSP()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                          )
       , tmpMIChild AS (SELECT MovementItem.ParentId
                             , string_agg( Object_Goods.Id :: TVarChar, ';')                 AS ChildIdList
                             , string_agg(zfConvert_FloatToString(MovementItem.Amount), ';') AS ChildAmountList
                        FROM tmpMovement 
                        
                             INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Child()
                                                    AND MovementItem.MovementId = tmpMovement.Id
                                                    AND MovementItem.isErased = FALSE 

                             LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.GoodsMainId = MovementItem.ObjectId
                                                          AND Object_Goods.RetailId = vbRetailId

                        GROUP BY MovementItem.ParentId
                        )
      ,  tmpMISecond AS (SELECT MovementItem.ParentId
                             , string_agg( Object_Goods.Id :: TVarChar, ';')                 AS SecondIdList
                             , string_agg(zfConvert_FloatToString(MovementItem.Amount), ';') AS SecondAmountList
                         FROM tmpMovement 
                        
                              INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Second()
                                                     AND MovementItem.MovementId = tmpMovement.Id
                                                     AND MovementItem.isErased = FALSE 

                              LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                         GROUP BY MovementItem.ParentId
                        )

        SELECT tmpMovement.Id
             , MovementItem.Id
             , MovementItem.Amount::Integer               AS Queue
             , tmpMovement.OperDateEnd                    AS OperDateEnd
             , tmpMIChild.ChildIdList::TVarChar           AS ChildIdList 
             , tmpMIChild.ChildAmountList::TVarChar       AS ChildAmountList 
             , tmpMISecond.SecondIdList::TVarChar         AS GoodsNamePresent 
             , tmpMISecond.SecondAmountList::TVarChar     AS AmountPresent 

        FROM tmpMovement 
                        
             INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Master()
                                    AND MovementItem.MovementId = tmpMovement.Id
                                    AND MovementItem.isErased = FALSE 

             LEFT JOIN tmpMIChild ON tmpMIChild.ParentId = MovementItem.Id

             LEFT JOIN tmpMISecond ON tmpMISecond.ParentId = MovementItem.Id

        WHERE COALESCE(tmpMIChild.ChildIdList, '') <> '' AND COALESCE(tmpMISecond.SecondIdList, '') <> ''
        ORDER BY MovementItem.Amount, tmpMovement.Id, MovementItem.Id;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.03.23                                                       *
*/

--ТЕСТ
-- 

select * from gpSelect_AsinoPharmaSP_Cash(inSession := '3');