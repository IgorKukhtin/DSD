-- Function: gpUpdate_MI_GoodsSPSearch_1303_FillingGoods()

DROP FUNCTION IF EXISTS gpUpdate_MI_GoodsSPSearch_1303_FillingGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_GoodsSPSearch_1303_FillingGoods(
    IN inMovementId          Integer   ,    -- Идентификатор документа
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';    
    END IF;
    
    -- Провкряем элемент по документу
    IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND COALESCE (ObjectId, 0) <> 0)
    THEN
        RAISE EXCEPTION 'Связи уже установлены.';
    END IF;    

    IF NOT EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                  WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 11041603 )
       AND vbUserId <> 3
    THEN
        RAISE EXCEPTION 'Ошибка. У вас нет прав выполнять эту операцию.';     
    END IF;    
    
    
    -- Нашли предыдущий
    SELECT MAX(Movement.Id)
    INTO vbMovementId
    FROM Movement
    WHERE Movement.DescId = zc_Movement_GoodsSPSearch_1303()
      AND Movement.StatusId <> zc_Enum_Status_Erased()
      AND Movement.Id < inMovementId;


    CREATE TEMP TABLE tmpGoodsSPSearch ON COMMIT DROP AS
    SELECT T2.*
         , REPLACE(T2.CodeATX, ' ', '') AS RCodeATX
         , ROW_NUMBER() OVER (PARTITION BY REPLACE(T2.CodeATX, ' ', '')
                                         , T2.ReestrSP
                                         , T2.IntenalSP_1303Id
                                         , T2.BrandSPId
                                         , T2.KindOutSP_1303Id
                                         , T2.Dosage_1303Id
                                         , T2.CountSP_1303Id
                                        ORDER BY T2.OrderDateSP DESC) AS Ord
    FROM gpSelect_MovementItem_GoodsSPSearch_1303(inMovementId :=  inMovementId   , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3') AS T2;
                                
    ANALYSE tmpGoodsSPSearch;

    CREATE TEMP TABLE tmpGoodsSPRegistry ON COMMIT DROP AS
    SELECT DISTINCT
           T1.GoodsId
         , T1.GoodsCode
         , REPLACE(T1.CodeATX, ' ', '') AS RCodeATX
         , T1.ReestrSP
         , T1.IntenalSP_1303Id
         , T1.BrandSPId
         , T1.KindOutSP_1303Id
         , T1.Dosage_1303Id
         , T1.CountSP_1303Id
    FROM gpSelect_MovementItem_GoodsSPSearch_1303(inMovementId := vbMovementId    , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3') AS T1
    WHERE COALESCE(T1.GoodsId, 0) <> 0
      AND (COALESCE(T1.GoodsId, 0) NOT IN (SELECT tmpGoodsSPSearch.GoodsId FROM tmpGoodsSPSearch)
           OR NOT EXISTS (SELECT tmpGoodsSPSearch.GoodsId FROM tmpGoodsSPSearch WHERE tmpGoodsSPSearch.GoodsId IS NOT NULL));
                                         
    ANALYSE tmpGoodsSPRegistry;
      
    PERFORM gpUpdate_MI_GoodsSPSearch_1303_Goods(inId := GoodsSPSearch.Id 
                                               , inMovementId := inMovementId
                                               , inGoodsID := GoodsSPSearch.GoodsId 
                                               , inCol := GoodsSPSearch.Col
                                               , inSession := inSession)
    FROM (

      SELECT tmpGoodsSPSearch.Id 
           , Min(tmpGoodsSPRegistry.GoodsId)::Integer AS GoodsId
           , tmpGoodsSPSearch.Col
      FROM tmpGoodsSPSearch

           INNER JOIN tmpGoodsSPRegistry ON tmpGoodsSPRegistry.RCodeATX = tmpGoodsSPSearch.RCodeATX
                                        AND tmpGoodsSPRegistry.ReestrSP = tmpGoodsSPSearch.ReestrSP
                                        AND COALESCE(tmpGoodsSPRegistry.IntenalSP_1303Id, 0) = COALESCE(tmpGoodsSPSearch.IntenalSP_1303Id, 0)
                                        AND COALESCE(tmpGoodsSPRegistry.BrandSPId, 0) = COALESCE(tmpGoodsSPSearch.BrandSPId, 0)
                                        AND tmpGoodsSPRegistry.KindOutSP_1303Id = tmpGoodsSPSearch.KindOutSP_1303Id
                                        AND tmpGoodsSPRegistry.Dosage_1303Id = tmpGoodsSPSearch.Dosage_1303Id
                                        AND tmpGoodsSPRegistry.CountSP_1303Id = tmpGoodsSPSearch.CountSP_1303Id

      WHERE COALESCE(tmpGoodsSPRegistry.GoodsId, 0) <> 0
        AND tmpGoodsSPSearch.Ord = 1

      GROUP BY tmpGoodsSPSearch.Id
             , tmpGoodsSPSearch.Col
             , tmpGoodsSPSearch.RCodeATX
             , tmpGoodsSPSearch.ReestrSP
             , tmpGoodsSPSearch.IntenalSP_1303Id
             , tmpGoodsSPSearch.BrandSPId
             , tmpGoodsSPSearch.KindOutSP_1303Id
             , tmpGoodsSPSearch.Dosage_1303Id
             , tmpGoodsSPSearch.CountSP_1303Id
      HAVING COUNT(*) = 1) AS GoodsSPSearch;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 124.08.24                                                       *
*/

-- select * from gpUpdate_MI_GoodsSPSearch_1303_FillingGoods(inMovementId := 33332437 ,  inSession := '3');