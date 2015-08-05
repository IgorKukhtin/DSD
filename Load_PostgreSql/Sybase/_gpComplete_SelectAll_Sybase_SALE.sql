-- Function: gpComplete_SelectAll_Sybase()

DROP FUNCTION IF EXISTS gpComplete_SelectAll_Sybase (TDateTime, TDateTime, Boolean);

CREATE OR REPLACE FUNCTION gpComplete_SelectAll_Sybase(
    IN inStartDate          TDateTime , -- 
    IN inEndDate            TDateTime , --
    IN inIsBefoHistoryCost  Boolean
)                              
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, Code TVarChar, ItemName TVarChar
              )
AS
$BODY$
BEGIN

     RETURN QUERY 
     WITH tmpUnit AS (/*SELECT 8411 AS UnitId, FALSE AS isMain -- Склад гп ф.Киев
                UNION SELECT 8413 AS UnitId, FALSE AS isMain  -- ф. Кр.Рог
                UNION SELECT 8415 AS UnitId, FALSE AS isMain  -- ф. Черкассы ( Кировоград)
                UNION SELECT 8417 AS UnitId, FALSE AS isMain  -- ф. Николаев (Херсон)
                UNION SELECT 8421 AS UnitId, FALSE AS isMain  -- ф. Донецк
                UNION SELECT 8425 AS UnitId, FALSE AS isMain  -- ф. Харьков
                UNION SELECT 301309 AS UnitId, FALSE AS isMain  -- Склад ГП ф.Запорожье
                -- UNION SELECT 309599 AS UnitId, FALSE AS isMain  -- Склад возвратов ф.Запорожье
                UNION SELECT 18341 AS UnitId, FALSE AS isMain  -- ф. Никополь
                UNION SELECT 8419 AS UnitId, FALSE AS isMain  -- ф. Крым
                UNION SELECT 8423 AS UnitId, FALSE AS isMain  -- ф. Одесса
                UNION SELECT 346093  AS UnitId, FALSE AS isMain  -- Склад ГП ф.Одесса
                -- UNION SELECT 346094  AS UnitId, FALSE AS isMain  -- Склад возвратов ф.Одесса

                UNION SELECT tmp.UnitId, TRUE AS isMain FROM lfSelect_Object_Unit_byGroup (8446) AS tmp -- ЦЕХ колбаса+дел-сы
                UNION SELECT tmp.UnitId, TRUE AS isMain FROM lfSelect_Object_Unit_byGroup (8454) AS tmp -- Склад специй и запчастей

                UNION */SELECT tmp.UnitId, TRUE AS isMain FROM lfSelect_Object_Unit_byGroup (8432) AS tmp -- 30000 - Общепроизводственные
               )
     -- 1. From: Sale + SendOnPrice
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

          LEFT JOIN tmpUnit AS tmpUnit_from ON tmpUnit_from.UnitId = MLO_From.ObjectId
          LEFT JOIN tmpUnit AS tmpUnit_To ON tmpUnit_To.UnitId = MLO_To.ObjectId

     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId IN (zc_Movement_Sale())
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND (tmpUnit_from.UnitId > 0)
    ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.11.14                                        *
*/



/*


select  lpInsertUpdate_MovementFloat_TotalSumm (Movement.Id)
from
(select 777 as inv
union all select 776 as inv
union all select 775 as inv
union all select 773 as inv
union all select 772 as inv
union all select 771 as inv
union all select 743 as inv
union all select 446 as inv
union all select 445 as inv
union all select 443 as inv
union all select 440 as inv
union all select 437 as inv
union all select 436 as inv
union all select 435 as inv
union all select 454 as inv
union all select 453 as inv
union all select 452 as inv
union all select 449 as inv
union all select 447 as inv
union all select 498 as inv
union all select 496 as inv
union all select 495 as inv
union all select 494 as inv
union all select 493 as inv
union all select 491 as inv
union all select 490 as inv
union all select 488 as inv
union all select 487 as inv
union all select 486 as inv
union all select 485 as inv
union all select 484 as inv
union all select 462 as inv
union all select 774 as inv
) as a
left join  Movement ON Movement.OperDate BETWEEN '01.07.2015' AND '10.07.2015'  
              AND Movement.DescId = zc_Movement_SendOnPrice() AND Movement.StatusId = zc_Enum_Status_Complete()
              AND Movement.InvNumber = a.inv :: TVarChar







select lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), Id, cast (Amount * 0.99 AS NUMERIC (16, 2)))
     , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountChangePercent(), Id, cast (Amount * 0.99 AS NUMERIC (16, 2)))
     , lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercentAmount(), Id, 1)

from(


select  MovementItem.Id, MovementItem.Amount
from
(select 777 as inv
union all select 776 as inv
union all select 775 as inv
union all select 773 as inv
union all select 772 as inv
union all select 771 as inv
union all select 743 as inv
union all select 446 as inv
union all select 445 as inv
union all select 443 as inv
union all select 440 as inv
union all select 437 as inv
union all select 436 as inv
union all select 435 as inv
union all select 454 as inv
union all select 453 as inv
union all select 452 as inv
union all select 449 as inv
union all select 447 as inv
union all select 498 as inv
union all select 496 as inv
union all select 495 as inv
union all select 494 as inv
union all select 493 as inv
union all select 491 as inv
union all select 490 as inv
union all select 488 as inv
union all select 487 as inv
union all select 486 as inv
union all select 485 as inv
union all select 484 as inv
union all select 462 as inv
union all select 774 as inv
) as a
left join  Movement ON Movement.OperDate BETWEEN '01.07.2015' AND '10.07.2015'  
              AND Movement.DescId = zc_Movement_SendOnPrice() AND Movement.StatusId = zc_Enum_Status_Complete()
              AND Movement.InvNumber = a.inv :: TVarChar

left join MovementItem ON MovementItem.MovementId = Movement.Id

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()


where ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg()
-- and Movement.InvNumber = '777'
) as aaaa

*/