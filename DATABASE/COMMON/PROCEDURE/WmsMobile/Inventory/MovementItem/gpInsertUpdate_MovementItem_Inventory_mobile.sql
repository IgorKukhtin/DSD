-- Function: gpInsertUpdate_MovementItem_Inventory_mobile()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory_mobile (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory_mobile(
    IN inMovementItemId      Integer   , -- Ключ объекта <Элемент документа>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementId   Integer;
   DECLARE vbOperDate     TDateTime;

   DECLARE vbMovementItemId_find Integer;
   DECLARE vbId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory_mobile());
     vbUserId:= lpGetUserBySession (inSession);


     -- Дата в зависимости от смены
     vbOperDate:= CURRENT_DATE; -- gpGet_Scale_OperDate (inIsCeh:= FALSE, inBranchCode:= 1, inSession:= inSession);


     -- Проверка что еще не сканировали Паспорт
     vbMovementItemId_find:= (SELECT MovementItem.Id
                              FROM Movement
                                   INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                                            AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                                                            AND MLO_From.ObjectId   = zc_Unit_RK()
                                   INNER JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                                          AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                                          AND MLO_To.ObjectId   = zc_Unit_RK()
                                   INNER JOIN MovementFloat AS MovementFloat_MovementDesc
                                                            ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                                           AND MovementFloat_MovementDesc.DescId     = zc_MovementFloat_MovementDesc()
                                                           AND MovementFloat_MovementDesc.ValueData  = zc_Movement_Inventory() :: TFloat
                                   -- Автоматический
                                   INNER JOIN MovementBoolean AS MB_isAuto ON MB_isAuto.MovementId = Movement.Id
                                                                          AND MB_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                                          -- Автоматический, значит с КПК
                                                                          AND MB_isAuto.ValueData  = TRUE

                                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                                   -- Партия - Паспорт, которую надо проверить
                                   INNER JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                                ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                                               AND MIFloat_MovementItemId.DescId         = zc_MIFloat_MovementItemId()
                                                               AND MIFloat_MovementItemId.ValueData      = inMovementItemId :: TFloat

                              WHERE Movement.DescId = zc_Movement_WeighingProduction()
                                AND Movement.OperDate >= vbOperDate -- DATE_TRUNC ('MONTH', vbOperDate - INTERVAL '0 DAY')
                                AND Movement.StatusId <> zc_Enum_Status_Erased()
                              LIMIT 1
                             );


     -- Проверка что его еще не сканировали
     IF vbMovementItemId_find > 0
     THEN
         --
         RAISE EXCEPTION 'Ошибка.Паспорт уже сканировался для инвентаризации.% <%> % <%>'
                       , CHR (13)
                       , (SELECT lfGet_Object_ValueData_sh (MLO.ObjectId) FROM MovementItem JOIN MovementLinkObject AS MLO ON MLO.MovementId = MovementItem.MovementId AND MLO.DescId = zc_MovementLinkObject_User() WHERE MovementItem.Id = vbMovementItemId_find)
                       , CHR (13)
                       , (SELECT zfConvert_DateTimeToString (MIDate.ValueData) FROM MovementItemDate AS MIDate WHERE MIDate.MovementItemId = vbMovementItemId_find AND MIDate.DescId = zc_MIDate_Insert())
                     --, CHR (13)
                     --, vbMovementItemId_find
                        ;
     END IF;


     -- пробуем найти документ
     vbMovementId:= (SELECT Movement.Id
                     FROM Movement
                          INNER JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                                   AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                                                   AND MLO_From.ObjectId   = zc_Unit_RK()
                          INNER JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                                 AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                                 AND MLO_To.ObjectId   = zc_Unit_RK()
                          INNER JOIN MovementFloat AS MovementFloat_MovementDesc
                                                   ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                                  AND MovementFloat_MovementDesc.DescId     = zc_MovementFloat_MovementDesc()
                                                  AND MovementFloat_MovementDesc.ValueData  = zc_Movement_Inventory() :: TFloat
                          -- Автоматический
                          INNER JOIN MovementBoolean AS MB_isAuto ON MB_isAuto.MovementId = Movement.Id
                                                                 AND MB_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                                 -- Автоматический, значит с КПК
                                                                 AND MB_isAuto.ValueData  = TRUE

                          -- Пользователь
                          INNER JOIN MovementLinkObject AS MLO_User
                                                        ON MLO_User.MovementId = Movement.Id
                                                       AND MLO_User.DescId     = zc_MovementLinkObject_User()
                                                       AND MLO_User.ObjectId   = vbUserId

                     WHERE Movement.DescId = zc_Movement_WeighingProduction()
                       AND Movement.OperDate = vbOperDate
                       AND Movement.StatusId = zc_Enum_Status_UnComplete()
                     LIMIT 1
                    );


     IF COALESCE (vbMovementId,0) = 0
     THEN
         -- сохранили
         vbMovementId := gpInsertUpdate_Movement_WeighingProduction (ioId                  := 0
                                                                   , inOperDate            := vbOperDate
                                                                   , inMovementDescId      := zc_Movement_Inventory()
                                                                   , inMovementDescNumber  := 11
                                                                   , inWeighingNumber      := (1 + COALESCE ((SELECT MAX (COALESCE (MovementFloat_WeighingNumber.ValueData, 0))
                                                                                                                       FROM Movement
                                                                                                                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                                                                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                                                                                                                         AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                                                                                                                                         AND MovementLinkObject_From.ObjectId   = zc_Unit_RK()
                                                                                                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                                                                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                                                                                                                         AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                                                                                                                         AND MovementLinkObject_To.ObjectId   = zc_Unit_RK()
                                                                                                                            INNER JOIN MovementFloat AS MovementFloat_MovementDesc
                                                                                                                                                     ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                                                                                                                                    AND MovementFloat_MovementDesc.DescId     = zc_MovementFloat_MovementDesc()
                                                                                                                                                    AND MovementFloat_MovementDesc.ValueData  = zc_Movement_Inventory() :: TFloat
                                                                                                                            INNER JOIN MovementFloat AS MovementFloat_WeighingNumber
                                                                                                                                                     ON MovementFloat_WeighingNumber.MovementId = Movement.Id
                                                                                                                                                    AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()
                                                                                                                       WHERE Movement.DescId = zc_Movement_WeighingProduction()
                                                                                                                         AND Movement.OperDate = vbOperDate
                                                                                                                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                                                                                      ), 0)
                                                                                              )  :: Integer
                                                                   , inFromId              := zc_Unit_RK()
                                                                   , inToId                := zc_Unit_RK()
                                                                   , inDocumentKindId      := 0
                                                                   , inSubjectDocId        := 0
                                                                   , inPersonalGroupId     := 0
                                                                   , inMovementId_Order    := 0
                                                                   , inPartionGoods        := ''
                                                                   , inIsProductionIn      := TRUE
                                                                   , inComment             := ''
                                                                   , inSession             := inSession
                                                                    );

         -- сохранили - Автоматический
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId, TRUE);

         -- дописали свойство <Код Филиала>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_BranchCode(), vbMovementId, 1);

     END IF;


     -- сохранили
     vbId:= gpInsertUpdate_MovementItem_WeighingProduction (ioId                  := 0
                                                          , inMovementId          := vbMovementId
                                                          , inGoodsId             := gpGet.GoodsId
                                                          , inAmount              := CASE WHEN gpGet.MeasureId = zc_Measure_Sh() THEN gpGet.Amount_sh ELSE gpGet.Amount END
                                                          , inIsStartWeighing     := TRUE
                                                          , inRealWeight          := gpGet.Amount + gpGet.WeightTare_calc
                                                          , inWeightTare          := gpGet.WeightTare_calc
                                                          , inLiveWeight          := 0
                                                          , inHeadCount           := 0
                                                          , inCount               := 0
                                                          , inCountPack           := 0
                                                          , inCountSkewer1        := 0
                                                          , inWeightSkewer1       := 0
                                                          , inCountSkewer2        := 0
                                                          , inWeightSkewer2       := 0
                                                          , inWeightOther         := 0
                                                          , inPartionGoodsDate    := gpGet.PartionGoodsDate
                                                          , inPartionGoods        := ''
                                                          , inNumberKVK           := ''
                                                          , inMovementItemId      := inMovementItemId
                                                          , inGoodsKindId         := gpGet.GoodsKindId
                                                          , inStorageLineId       := 0
                                                          , inPersonalId_KVK      := GoodsKindId
                                                          , inSession             := inSession
                                                           )
     FROM gpGet_MovementItem_Inventory_mobile (zfFormat_BarCode (zc_BarCodePref_MI(), inMovementItemId) || '0', inSession) AS gpGet
    ;

     -- Пользователь (создание)
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), vbId, vbUserId);


IF vbUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION 'Ошибка.OK';
END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.02.25         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory_mobile (317323409, zfCalc_UserAdmin())
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory_mobile (317382349, zfCalc_UserAdmin())
