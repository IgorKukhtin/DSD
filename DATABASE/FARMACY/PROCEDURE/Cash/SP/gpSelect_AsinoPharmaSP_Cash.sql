 -- Function: gpSelect_AsinoPharmaSP_Cash()

DROP FUNCTION IF EXISTS gpSelect_AsinoPharmaSP_Cash (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_AsinoPharmaSP_Cash(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Queue              Integer
             , OperDateEnd        TDateTime
             , CountPair          Integer
             , JuridicalId        Integer
             , JuridicalName      TVarChar             
             , GoodsMainId1       Integer
             , MainAmount1        TFloat
             , MainAmountOk1      TFloat
             , GoodsMainId2       Integer
             , MainAmount2        TFloat
             , MainAmountOk2      TFloat
             , GoodsPresentId1    Integer
             , PresentAmount1     TFloat
             , PresentAmountOk1   TFloat
             , GoodsPresentId2    Integer
             , PresentAmount2     TFloat
             , PresentAmountOk2   TFloat
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
       , tmpMI AS (SELECT MovementItem.Id              
                        , tmpMovement.OperDateEnd       
                        , ROW_NUMBER() OVER (ORDER BY tmpMovement.Id DESC, MovementItem.Amount)::Integer AS Queue
                   FROM tmpMovement

                        INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Master()
                                               AND MovementItem.MovementId = tmpMovement.Id
                                               AND MovementItem.isErased = FALSE 

                  )
       , tmpMIChild AS (SELECT MovementItem.ParentId
                             , Object_Goods.Id        AS ChildId
                             , MovementItem.Amount    AS ChildAmount
                             , ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId ORDER BY Object_Goods.Id DESC) AS Ord
                        FROM tmpMovement 
                        
                             INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Child()
                                                    AND MovementItem.MovementId = tmpMovement.Id
                                                    AND MovementItem.isErased = FALSE 

                             INNER JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.GoodsMainId = MovementItem.ObjectId
                                                           AND Object_Goods.RetailId = vbRetailId

                        )
      ,  tmpMISecond AS (SELECT MovementItem.ParentId
                              , Object_Goods.Id     AS SecondId
                              , MovementItem.Amount AS SecondAmount
                              , ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId ORDER BY Object_Goods.Id DESC) AS Ord
                         FROM tmpMovement 
                        
                              INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Second()
                                                     AND MovementItem.MovementId = tmpMovement.Id
                                                     AND MovementItem.isErased = FALSE 

                              INNER JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.GoodsMainId = MovementItem.ObjectId
                                                            AND Object_Goods.RetailId = vbRetailId

                        )
       , tmpMICount AS (SELECT MovementItem.ParentId
                             , count(*)::Integer           AS CountPair
                        FROM tmpMovement 
                        
                             INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Child()
                                                    AND MovementItem.MovementId = tmpMovement.Id
                                                    AND MovementItem.isErased = FALSE 
                                                    
                        GROUP BY MovementItem.ParentId
                        )

        SELECT tmpMI.Queue                                AS Queue
             , tmpMI.OperDateEnd                          AS OperDateEnd
             , tmpMICount.CountPair                       AS CountPair

             , 0::Integer                                 AS JuridicalId
             , ''::TVarChar                               AS JuridicalName

             , MIChild1.ChildId                           AS GoodsMainId1 
             , MIChild1.ChildAmount                       AS MainAmount1
             , 0::TFloat                                  AS MainAmountOk1
             , MIChild2.ChildId                           AS GoodsMainId2
             , MIChild2.ChildAmount                       AS MainAmount2
             , 0::TFloat                                  AS MainAmountOk2

             , MISecond1.SecondId                         AS GoodsPresentId1
             , MISecond1.SecondAmount                     AS PresentAmount1
             , 0::TFloat                                  AS PresentAmountOk1
             , MISecond2.SecondId                         AS GoodsPresentId2
             , MISecond2.SecondAmount                     AS PresentAmount2
             , 0::TFloat                                  AS PresentAmountOk2

        FROM tmpMI 
        
             LEFT JOIN tmpMICount ON tmpMICount.ParentId = tmpMI.Id

             LEFT JOIN tmpMIChild AS MIChild1
                                  ON MIChild1.ParentId = tmpMI.Id
                                 AND MIChild1.Ord = 1

             LEFT JOIN tmpMISecond AS MISecond1
                                   ON MISecond1.ParentId = tmpMI.Id
                                  AND MISecond1.Ord = MIChild1.Ord

             LEFT JOIN tmpMIChild AS MIChild2
                                  ON MIChild2.ParentId = tmpMI.Id
                                 AND MIChild2.Ord = 2

             LEFT JOIN tmpMISecond AS MISecond2
                                   ON MISecond2.ParentId = tmpMI.Id
                                  AND MISecond2.Ord = MIChild2.Ord

        --WHERE COALESCE(tmpMIChild.ChildIdList, '') <> '' AND COALESCE(tmpMISecond.SecondIdList, '') <> ''
        ORDER BY tmpMI.Queue;

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