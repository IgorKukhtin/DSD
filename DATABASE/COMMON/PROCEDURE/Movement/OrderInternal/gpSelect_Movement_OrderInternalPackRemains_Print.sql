-- Function: gpSelect_Movement_OrderInternalPackRemains_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternalPackRemains_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternalPackRemains_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id             Integer
             , GoodsId        Integer
             , GoodsCode      Integer
             , GoodsName      TVarChar
  
             , GoodsId_basis   Integer
             , GoodsCode_basis Integer
             , GoodsName_basis TVarChar
  
             , GoodsKindId       Integer
             , GoodsKindName     TVarChar
             , MeasureName       TVarChar
             , MeasureName_basis TVarChar
  
             , GoodsGroupNameFull TVarChar
  
             , Amount            TFloat
             , AmountSecond      TFloat
             , AmountTotal       TFloat
             , Num               Integer
             , Income_CEH        TFloat
             , Income_PACK_to    TFloat
             , Income_PACK_from  TFloat
              )
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime;

  --  DECLARE curMI_Master refcursor;
    
    DECLARE  vbId                Integer;
    DECLARE vbGoodsId           Integer;
    DECLARE vbGoodsCode         Integer;
    DECLARE vbGoodsName         TVarChar;
    DECLARE vbGoodsId_basis     Integer;
    DECLARE vbGoodsCode_basis   Integer;
    DECLARE vbGoodsName_basis   TVarChar;
    DECLARE vbGoodsKindId       Integer;
    DECLARE vbGoodsKindName     TVarChar;
    DECLARE vbMeasureName       TVarChar;
    DECLARE vbMeasureName_basis TVarChar;
    DECLARE vbGoodsGroupNameFull TVarChar;
    DECLARE vbAmount            TFloat;
    DECLARE vbAmountSecond      TFloat ;
    DECLARE vbAmountTotal       TFloat  ;
    DECLARE vbNum               Integer ;
    DECLARE vbIncome_CEH        TFloat  ;
    DECLARE vbIncome_PACK_to    TFloat  ;
    DECLARE vbIncome_PACK_from  TFloat  ;
    
    DECLARE curMI_Master CURSOR FOR 
                   SELECT  tmpMaster.Id
                         , tmpMaster.GoodsId
                         , tmpMaster.GoodsCode
                         , tmpMaster.GoodsName
              
                         , tmpMaster.GoodsId_basis
                         , tmpMaster.GoodsCode_basis
                         , tmpMaster.GoodsName_basis
              
                         , tmpMaster.GoodsKindId
                         , tmpMaster.GoodsKindName
                         , tmpMaster.MeasureName
                         , tmpMaster.MeasureName_basis
              
                         , tmpMaster.GoodsGroupNameFull
              
              
                         , tmpMaster.Amount        -- ***Ост. на УПАК
                         , tmpMaster.AmountSecond  -- ***План ПР-ВО на УПАК
                         , tmpMaster.AmountTotal   -- ***План ПР-ВО на УПАК
              
                         , tmpMaster.Num
                         , tmpMaster.Income_CEH
                         , tmpMaster.Income_PACK_to
                         , tmpMaster.Income_PACK_from
              
                   FROM gpSelect_MI_OrderInternalPackRemains (inMovementId:= inMovementId, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= inSession) AS tmpMaster; --FETCH ALL "<unnamed portal 1>";

           
   
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
      INTO vbDescId, vbStatusId, vbOperDate
     FROM Movement
     WHERE Movement.Id = inMovementId;

     -- очень важная проверка
     IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete() AND vbUserId <> 5 -- !!!кроме Админа!!!
     THEN
         IF vbStatusId = zc_Enum_Status_Erased()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         IF vbStatusId = zc_Enum_Status_UnComplete()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         -- это уже странная ошибка
         RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
     END IF;


CREATE TEMP TABLE _tmpMI_master (Id             Integer
                               , GoodsId        Integer
                               , GoodsCode      Integer
                               , GoodsName      TVarChar
                               , GoodsId_basis   Integer
                               , GoodsCode_basis Integer
                               , GoodsName_basis TVarChar
                               , GoodsKindId       Integer
                               , GoodsKindName     TVarChar
                               , MeasureName       TVarChar
                               , MeasureName_basis TVarChar
                               , GoodsGroupNameFull TVarChar
                               , Amount            TFloat
                               , AmountSecond      TFloat
                               , AmountTotal       TFloat
                               , Num               Integer
                               , Income_CEH        TFloat
                               , Income_PACK_to    TFloat
                               , Income_PACK_from  TFloat
                               ) ON COMMIT DROP;
      --
             -- курсор1 - 
              OPEN curMI_Master ;
              LOOP 
                  -- данные 
                  FETCH curMI_Master 
                   INTO   vbId, vbGoodsId, vbGoodsCode, vbGoodsName         
                                          , vbGoodsId_basis, vbGoodsCode_basis, vbGoodsName_basis   
                                          , vbGoodsKindId, vbGoodsKindName, vbMeasureName , vbMeasureName_basis 
                                          , vbGoodsGroupNameFull
                                          , vbAmount, vbAmountSecond, vbAmountTotal, vbNum
                                          , vbIncome_CEH, vbIncome_PACK_to, vbIncome_PACK_from  
                                          ;          
                  
                 IF NOT FOUND THEN EXIT; END IF;
  
                  -- !!сохраняем в табл-результата!!!
                  INSERT INTO _tmpMI_master ( Id, GoodsId, GoodsCode, GoodsName         
                                            , GoodsId_basis, GoodsCode_basis, GoodsName_basis   
                                            , GoodsKindId, GoodsKindName, MeasureName, MeasureName_basis 
                                            , GoodsGroupNameFull
                                            , Amount, AmountSecond, AmountTotal, Num
                                            , Income_CEH, Income_PACK_to, Income_PACK_from  
                                            )
                     SELECT vbId, vbGoodsId, vbGoodsCode, vbGoodsName         
                          , vbGoodsId_basis, vbGoodsCode_basis, vbGoodsName_basis   
                          , vbGoodsKindId, vbGoodsKindName, vbMeasureName , vbMeasureName_basis 
                          , vbGoodsGroupNameFull
                          , vbAmount, vbAmountSecond, vbAmountTotal, vbNum
                          , vbIncome_CEH, vbIncome_PACK_to, vbIncome_PACK_from  
                         ;
END LOOP;
 -- финиш цикла по курсору1
              CLOSE curMI_Master; -- закрыли курсор1
              DEALLOCATE curMI_Master;

          RETURN QUERY
           SELECT _tmpMI_master.Id, _tmpMI_master.GoodsId, _tmpMI_master.GoodsCode, _tmpMI_master.GoodsName   
                , _tmpMI_master.GoodsId_basis, _tmpMI_master.GoodsCode_basis, _tmpMI_master.GoodsName_basis
                , _tmpMI_master.GoodsKindId, _tmpMI_master.GoodsKindName, _tmpMI_master.MeasureName, _tmpMI_master.MeasureName_basis
                , _tmpMI_master.GoodsGroupNameFull
                , _tmpMI_master.Amount, _tmpMI_master.AmountSecond, _tmpMI_master.AmountTotal, _tmpMI_master.Num
                , _tmpMI_master.Income_CEH, _tmpMI_master.Income_PACK_to, _tmpMI_master.Income_PACK_from
                
           FROM _tmpMI_master;
  

  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_OrderInternalPackRemains_Print (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.06.15                                        *
*/

-- тест
--
-- 
SELECT * FROM gpSelect_Movement_OrderInternalPackRemains_Print (inMovementId := 388160, inSession:= zfCalc_UserAdmin())
