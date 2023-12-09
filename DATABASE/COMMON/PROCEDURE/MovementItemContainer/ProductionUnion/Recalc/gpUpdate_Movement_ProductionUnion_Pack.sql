-- Function: gpUpdate_Movement_ProductionUnion_Pack (TDateTime, TDateTime, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Movement_ProductionUnion_Pack (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ProductionUnion_Pack(
    IN inStartDate    TDateTime , --
    IN inEndDate      TDateTime , --
    IN inUnitId       Integer,    -- 
    IN inSession      TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_ProductionUnion_Pack());

   --
   --IF EXTRACT (MONTH FROM inStartDate) IN (2) THEN RETURN; END IF;
   --IF EXTRACT (DAY FROM inStartDate) <= 11 THEN RETURN; END IF;
   --IF EXTRACT (DAY FROM inStartDate) >= 24 THEN RAISE EXCEPTION 'Ошибка.end'; END IF;
   --
	
   IF (DATE_TRUNC ('MONTH', inStartDate) < DATE_TRUNC ('MONTH', CURRENT_DATE)
       OR EXTRACT (DAY FROM CURRENT_DATE) >= 20
      )
      AND inStartDate <>  CURRENT_DATE - INTERVAL '1 DAY'
      AND (EXTRACT (DAY FROM inStartDate)  / 2 - FLOOR (EXTRACT (DAY FROM inStartDate)  / 2)
        <> (0 + EXTRACT (DAY FROM CURRENT_DATE)) / 2 - FLOOR ((0 + EXTRACT (DAY FROM CURRENT_DATE)) / 2)
      --OR EXTRACT (DAY FROM inStartDate) < 14
          )
      AND 1=1
    --AND EXTRACT (DAY FROM inStartDate) IN (1, 3, 24, 26)
   THEN
       RETURN;
   END IF;

   -- ЦЕХ упаковки
   --IF inUnitId IN (8451) THEN RETURN; END IF
   
   --IF inStartDate <= '28.07.2023' THEN RETURN; END IF;

/*
IF inUnitId NOT IN (951601) -- ЦЕХ упаковки мясо
THEN
    RETURN;
END IF;*/

/*IF inUnitId NOT IN (8451, 951601)
THEN
    RAISE EXCEPTION 'Ошибка.<%>', lfGet_Object_ValueData_sh (inUnitId);
ELSE
    RETURN;
END IF;*/

   -- 
   IF EXISTS (SELECT 1
              FROM Movement
                   JOIN MovementBoolean AS MB ON MB.MovementId = Movement.Id AND MB.DescId = zc_MovementBoolean_Closed() AND MB.ValueData =  TRUE
                   INNER JOIN MovementLinkObject AS MLO_From
                                                 ON MLO_From.MovementId = Movement.Id
                                                AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                                AND MLO_From.ObjectId   = inUnitId
                   INNER JOIN MovementLinkObject AS MLO_To
                                                 ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                AND MLO_To.ObjectId   = inUnitId
              WHERE Movement.OperDate = inStartDate
                AND Movement.DescId   = zc_Movement_ProductionUnion()
                AND Movement.StatusId = zc_Enum_Status_Complete()
             )
   THEN
       RETURN;
   END IF;

   -- Пересчет
   PERFORM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate  := TRUE
                                                 , inStartDate := inStartDate
                                                 , inEndDate   := inEndDate
                                                 , inUnitId    := inUnitId
                                                 , inUserId    := zc_Enum_Process_Auto_Pack() -- vbUserId
                                                 );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.07.15                                        *
*/

/*
--  update MovementItem set isErased  = true from (
 with tmp as  (
-- SELECT distinct MovementItem.ObjectId, MovementItem.MovementId , MovementItem.ParentId 
 SELECT MovementItem.ObjectId, MovementItem.MovementId , MovementItem.Id , MovementItem.ParentId 
         -- , ROW_NUMBER() OVER (PARTITION BY MovementItem.MovementId , MovementItem.ObjectId, MovementItem.ParentId  ORDER BY MovementItem.Id DESC) AS Ord
-- SELECT distinct View_InfoMoney.*
              FROM Movement
                   JOIN MovementBoolean AS MB ON MB.MovementId = Movement.Id AND MB.DescId = zc_MovementBoolean_Closed() AND MB.ValueData =  TRUE
                   INNER JOIN MovementLinkObject AS MLO_From
                                                 ON MLO_From.MovementId = Movement.Id
                                                AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                                AND MLO_From.ObjectId   IN (8451, 951601)
                   INNER JOIN MovementLinkObject AS MLO_To
                                                 ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                AND MLO_To.ObjectId   IN (8451, 951601)

                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId     = zc_MI_Child()
                                                AND MovementItem.isErased = true
                   JOIN MovementItemProtocol on MovementItemProtocol.MovementItemId = MovementItem.Id
 and MovementItemProtocol.userId = 343013 -- vpn2.alan.dp.ua
-- and MovementItemProtocol.userId =  80372

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

              WHERE Movement.OperDate between '01.03.2022' and '31.03.2022' 
                AND Movement.DescId   = zc_Movement_ProductionUnion()
                AND Movement.StatusId = zc_Enum_Status_Complete()
-- and MovementItem.ObjectId = 4364
and ObjectLink_Goods_InfoMoney.ChildObjectId = 8913
)

select tmp.* 
from tmp
where ParentId = 226604711
     --left join MovementItem on MovementItem.MovementId = tmp.MovementId 
       --                    and MovementItem.ObjectId  = tmp.ObjectId 
         --                  and MovementItem.ParentId  = tmp.ParentId  
           --                AND MovementItem.isErased = false
             --              AND MovementItem.DescId     = zc_MI_Child()
              --**  AND MovementItem.Id = tmp.Id

--** where ord = 1
--** and MovementItem.Id is null


-- ) as tmp
-- where tmp.ObjectId =  MovementItem.ObjectId 
-- and  tmp.MovementId  =  MovementItem.MovementId 
-- and  tmp.ParentId  =  MovementItem.ParentId
-- AND MovementItem.isErased = false
-- AND MovementItem.DescId     = zc_MI_Child()
--*** AND MovementItem.Id = tmp.Id

*/
-- тест
-- SELECT * FROM gpUpdate_Movement_ProductionUnion_Pack (inStartDate:= '10.12.2022', inEndDate:= '10.12.2022', inUnitId:= 8451, inSession:= zc_Enum_Process_Auto_PrimeCost() :: TVarChar) -- Цех Упаковки
