-- Function: gpGet_ScaleCeh_Movement_checkKVK()

DROP FUNCTION IF EXISTS gpGet_ScaleCeh_Movement_checkKVK (Integer, Integer, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_ScaleCeh_Movement_checkKVK (Integer, Integer, Integer, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ScaleCeh_Movement_checkKVK(
    IN inMovementDescId      Integer   , -- 
    IN inDocumentKindId      Integer   , -- 
    IN inGoodsId             Integer   , -- 
    IN inPartionGoodsDate    TDateTime , -- 
    IN inBranchCode          Integer   , -- 
    IN inValueStep           Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (isCheck  Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsCheck Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement_check());
     vbUserId:= lpGetUserBySession (inSession);


     vbIsCheck:= FALSE;

     -- определили <Приход или Расход>
     IF inMovementDescId = zc_Movement_ProductionUnion() AND inValueStep < 2
     THEN
         vbIsCheck:= EXISTS (WITH tmpPartionGoods AS (SELECT Object.Id AS PartionGoodsId
                                                      FROM Object
                                                           INNER JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                                                 ON ObjectLink_GoodsKindComplete.ObjectId = Object.Id
                                                                                AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                                                                                AND ObjectLink_GoodsKindComplete.ChildObjectId = zc_GoodsKind_Basis()
                                                      WHERE Object.ValueData = TO_CHAR (inPartionGoodsDate, 'DD.MM.YYYY')
                                                        AND Object.DescId = zc_Object_PartionGoods()
                                                     )
                                , tmpContainer AS (SELECT Container.*
                                                   FROM ContainerLinkObject AS CLO_PartionGoods
                                                        JOIN Container ON Container.Id       = CLO_PartionGoods.ContainerId
                                                                      AND Container.ObjectId = inGoodsId
                                                                      AND Container.DescId   = zc_Container_Count()
                                                   WHERE CLO_PartionGoods.ObjectId IN (SELECT DISTINCT tmpPartionGoods.PartionGoodsId FROM tmpPartionGoods)
                                                     AND CLO_PartionGoods.DescId   = zc_ContainerLinkObject_PartionGoods()
                                                  )
                              , tmpMIContainer AS (SELECT DISTINCT MIContainer.MovementId
                                                   FROM MovementItemContainer AS MIContainer
                                                   WHERE MIContainer.ContainerId IN (SELECT DISTINCT tmpContainer.Id FROM tmpContainer)
                                                   --AND MIContainer.DescId      = zc_MIContainer_Count()
                                                  )
                        , tmpMovement_kvk AS (SELECT Movement.Id AS MovementId, MovementItem.Id AS MovementItemId
                                              FROM Movement
                                                   JOIN MovementItem
                                                     ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.ObjectId   = inGoodsId
                                                    AND MovementItem.isErased   = FALSE
                                              WHERE Movement.Id     IN (SELECT DISTINCT tmpMIContainer.MovementId FROM tmpMIContainer)
                                              --AND Movement.DescId = zc_Movement_WeighingProduction()
                                             )
                              , tmpMI_kvk AS (SELECT MovementItemFloat.MovementItemId
                                              FROM MovementItemFloat
                                              WHERE MovementItemFloat.ValueData IN (SELECT DISTINCT tmpMovement_kvk.MovementItemId FROM tmpMovement_kvk)
                                                AND MovementItemFloat.DescId    = zc_MIFloat_MovementItemId()
                                             )
                             , tmpMIS_kvk AS (SELECT MIString_KVK.*
                                              FROM MovementItemString AS MIString_KVK
                                              WHERE MIString_KVK.MovementItemId IN (SELECT DISTINCT tmpMI_kvk.MovementItemId FROM tmpMI_kvk)
                                                AND MIString_KVK.DescId         = zc_MIString_KVK()
                                             )
                            , tmpMILO_kvk AS (SELECT MILinkObject_PersonalKVK.*
                                              FROM MovementItemLinkObject AS MILinkObject_PersonalKVK
                                              WHERE MILinkObject_PersonalKVK.MovementItemId IN (SELECT DISTINCT tmpMI_kvk.MovementItemId FROM tmpMI_kvk)
                                                AND MILinkObject_PersonalKVK.DescId         = zc_MILinkObject_PersonalKVK()
                                             )
                             , tmpMI_data AS (SELECT MIString_KVK.ValueData            AS NumberKVK
                                                   , MILinkObject_PersonalKVK.ObjectId AS PersonalId_KVK
                                              FROM tmpMI_kvk
                                                   LEFT JOIN tmpMIS_kvk AS MIString_KVK
                                                                        ON MIString_KVK.MovementItemId = tmpMI_kvk.MovementItemId
                                                                     --AND MIString_KVK.DescId = zc_MIString_KVK()
                                                   LEFT JOIN tmpMILO_kvk AS MILinkObject_PersonalKVK
                                                                         ON MILinkObject_PersonalKVK.MovementItemId = tmpMI_kvk.MovementItemId
                                                                     --AND MILinkObject_PersonalKVK.DescId = zc_MILinkObject_PersonalKVK()
                                             )
                             -- Результат
                             SELECT 1 FROM tmpMI_data WHERE tmpMI_data.NumberKVK <> '' OR tmpMI_data.PersonalId_KVK > 0
                            );
     END IF;


     -- Результат - все ок
     RETURN QUERY
        SELECT vbIsCheck AS isCheck;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 13.06.15                                        *
*/

-- тест
-- SELECT * FROM gpGet_ScaleCeh_Movement_checkKVK(inMovementDescId := 8 , inDocumentKindId := 2149855 , inGoodsId := 5316 , inPartionGoodsDate := ('21.09.2021')::TDateTime , inBranchCode := 102 , inValueStep := 0 ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');
