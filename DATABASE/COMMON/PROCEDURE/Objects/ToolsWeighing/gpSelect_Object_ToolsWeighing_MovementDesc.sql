-- Function: gpSelect_Object_ToolsWeighing_MovementDesc()

-- DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_MovementDesc (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ToolsWeighing_MovementDesc (Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ToolsWeighing_MovementDesc(
    IN inIsCeh       Boolean   , -- программа ScaleCeh - да/нет
    IN inBranchCode  Integer   , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Number              Integer
             , MovementDescId      Integer
             , MovementDescId_next Integer
             , FromId              Integer, FromCode         Integer, FromName         TVarChar
             , ToId                Integer, ToCode           Integer, ToName           TVarChar
             , FromId_next         Integer, FromCode_next    Integer, FromName_next    TVarChar
             , ToId_next           Integer, ToCode_next      Integer, ToName_next      TVarChar
             , PaidKindId          Integer, PaidKindName     TVarChar
             , InfoMoneyId         Integer, InfoMoneyCode    Integer, InfoMoneyName    TVarChar
             , PriceListId         Integer, PriceListCode    Integer, PriceListName    TVarChar
             , GoodsId_ReWork      Integer, GoodsCode_ReWork Integer, GoodsName_ReWork TVarChar
             , DocumentKindId      Integer, DocumentKindName TVarChar
             , ReasonId            Integer, ReasonCode       Integer, ReasonName       TVarChar, ReturnKindName TVarChar
             , GoodsKindWeighingGroupId Integer
             , ColorGridValue      Integer
             , MovementDescName          TVarChar
             , MovementDescName_master   TVarChar
             , MovementDescName_next     TVarChar
             , OrderById                 Integer
             , isSendOnPriceIn           Boolean
             , isPartionGoodsDate        Boolean -- Scale + ScaleCeh - для приемки с производства + расходы с РК - показываем контрол с датой для определения партии
             , isPartionDate_save        Boolean -- Scale + ScaleCeh - для приемки с производства + расходы с РК - показываем выбор сохранять да/нет
                                         
             , isStorageLine             Boolean -- ScaleCeh - будет проверка на ввод <Линия пр-ва> - для каждого взвешивания
             , isArticleLoss             Boolean -- ScaleCeh - проверка на установку <Статья списания>
             , isTransport_link          Boolean -- Scale - проверка <Штрих код Путевой лист>
             , isSubjectDoc              Boolean -- Scale + ScaleCeh - будет проверка на ввод <Основание Возврат>
             , isComment                 Boolean -- Scale + ScaleCeh - будет диалог для
             , isInvNumberPartner        Boolean -- 
             , isInvNumberPartner_check  Boolean -- 
             , isDocPartner              Boolean -- Документ поставщика
             , isPersonalGroup           Boolean -- ScaleCeh - будет проверка на ввод <№ бригады>
             , isOrderInternal           Boolean -- ScaleCeh - проверка для операции - разрешается только через заявку
             , isSticker_Ceh             Boolean -- ScaleCeh - при взвешивании в данной операции - сразу печатается Стикер на термопринтере
             , isSticker_KVK             Boolean -- ScaleCeh - при взвешивании в данной операции - сразу печатается Стикер-KVK на термопринтере
             , isLockStartWeighing       Boolean --
             , isKVK                     Boolean -- ScaleCeh - будет KVK
             , isListInventory           Boolean -- Scale + ScaleCeh - инвентаризация только для списка
             , isAsset                   Boolean -- Scale + ScaleCeh - открыть справочник ОС
             , isPartionCell             Boolean -- Scale + ScaleCeh - открыть справочник PartionCell
             , isPartionPassport         Boolean -- ScaleCeh - открыть диалог для формирования паспорта
             , isReReturnIn              Boolean -- Scale - открыть журнал документов Возврат от покупателя
             , isCloseInventory          Boolean
             , isCalc_Sh                 Boolean
             , isRePack                  Boolean -- 
             , isOperCountPartner        Boolean -- Кол-во контрагента
             , isOperPricePartner        Boolean -- Цена контрагента
             , isReturnOut_Date          Boolean -- Дата для цены возврат поставщику 
             , isCalc_PriceVat           Boolean -- Расчет цены с НДС или без
               )
AS
$BODY$
   DECLARE vbUserId     Integer;

   DECLARE vbIsSticker  Boolean;
   DECLARE vbLevelMain  TVarChar;
   DECLARE vbCount      Integer;
   DECLARE vbBranchId   Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


    -- !!!очень важно - захардкодили главную ветку!!!
    vbLevelMain:= CASE WHEN inIsCeh = TRUE THEN 'ScaleCeh_' || inBranchCode ELSE 'Scale_' || inBranchCode END;

    -- !!!важно - Печать этикеток - определили по BranchCode!!!
    vbIsSticker:= inBranchCode > 1000;


    -- определяется кол-во операций
    vbCount:= (SELECT gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', '', 'Count', CASE WHEN vbIsSticker = TRUE THEN '1' ELSE '10' END, inSession));
    -- определяется
    vbBranchId:= CASE WHEN inBranchCode > 1000 THEN (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inBranchCode - 1000 AND Object.DescId = zc_Object_Branch())
                      WHEN inBranchCode > 100 AND inBranchCode < 1000 THEN zc_Branch_Basis()
                      ELSE (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inBranchCode AND Object.DescId = zc_Object_Branch())
                 END;


    -- временные таблица
    CREATE TEMP TABLE _tmpToolsWeighing (Number                   Integer
                                       , MovementDescId           Integer
                                       , MovementDescId_next      Integer
                                       , FromId                   Integer
                                       , ToId                     Integer
                                       , FromId_next              Integer
                                       , ToId_next                Integer
                                       , PaidKindId               Integer
                                       , InfoMoneyId              Integer
                                       , GoodsId_ReWork           Integer
                                       , DocumentKindId           Integer
                                       , GoodsKindWeighingGroupId Integer
                                       , ColorGridValue           Integer
                                       , OrderById                Integer
                                       , isSendOnPriceIn          Boolean
                                       , isPartionGoodsDate       Boolean
                                       , isPartionDate_save       Boolean
                                       , isStorageLine            Boolean
                                       , isArticleLoss            Boolean
                                       , isTransport_link         Boolean
                                       , isSubjectDoc             Boolean
                                       , isComment                Boolean
                                       , isInvNumberPartner       Boolean
                                       , isInvNumberPartner_check Boolean
                                       , isDocPartner             Boolean
                                       , isPersonalGroup          Boolean
                                       , isOrderInternal          Boolean
                                       , isSticker_Ceh            Boolean
                                       , isSticker_KVK            Boolean
                                       , isLockStartWeighing      Boolean
                                       , isKVK                    Boolean
                                       , isListInventory          Boolean
                                       , isAsset                  Boolean
                                       , isPartionCell            Boolean
                                       , isPartionPassport        Boolean
                                       , isReReturnIn             Boolean
                                       , isCloseInventory         Boolean
                                       , isCalc_Sh                Boolean
                                       , isRePack                 Boolean
                                       , isOperCountPartner       Boolean
                                       , isOperPricePartner       Boolean
                                       , isReturnOut_Date         Boolean
                                       , isCalc_PriceVat          Boolean
                                       , ItemName                 TVarChar
                                        ) ON COMMIT DROP;
    -- формирование
    INSERT INTO _tmpToolsWeighing (Number, MovementDescId, MovementDescId_next, FromId, ToId, FromId_next, ToId_next
                                 , PaidKindId, InfoMoneyId, GoodsId_ReWork, DocumentKindId, GoodsKindWeighingGroupId, ColorGridValue, OrderById, isSendOnPriceIn
                                 , isPartionGoodsDate, isPartionDate_save, isStorageLine, isArticleLoss, isTransport_link, isSubjectDoc, isComment, isInvNumberPartner, isInvNumberPartner_check, isDocPartner, isPersonalGroup, isOrderInternal
                                 , isSticker_Ceh, isSticker_KVK, isLockStartWeighing, isKVK, isListInventory, isAsset
                                 , isPartionCell, isPartionPassport, isReReturnIn, isCloseInventory, isCalc_Sh, isRePack
                                 , isOperCountPartner, isOperPricePartner, isReturnOut_Date, isCalc_PriceVat
                                 , ItemName
                                  )
       SELECT tmp.Number
            , CASE WHEN TRIM (tmp.MovementDescId)           <> '' THEN TRIM (tmp.MovementDescId)           ELSE '0' END :: Integer AS MovementDescId
            , CASE WHEN TRIM (tmp.MovementDescId_next)      <> '' THEN TRIM (tmp.MovementDescId_next)      ELSE '0' END :: Integer AS MovementDescId_next
            , CASE WHEN TRIM (tmp.FromId)                   <> '' THEN TRIM (tmp.FromId)                   ELSE '0' END :: Integer AS FromId
            , CASE WHEN TRIM (tmp.ToId)                     <> '' THEN TRIM (tmp.ToId)                     ELSE '0' END :: Integer AS ToId
            , CASE WHEN TRIM (tmp.FromId_next)              <> '' THEN TRIM (tmp.FromId_next)              ELSE '0' END :: Integer AS FromId_next
            , CASE WHEN TRIM (tmp.ToId_next)                <> '' THEN TRIM (tmp.ToId_next)                ELSE '0' END :: Integer AS ToId_next
            , CASE WHEN TRIM (tmp.PaidKindId)               <> '' THEN TRIM (tmp.PaidKindId)               ELSE '0' END :: Integer AS PaidKindId
            , CASE WHEN TRIM (tmp.InfoMoneyId)              <> '' THEN TRIM (tmp.InfoMoneyId)              ELSE '0' END :: Integer AS InfoMoneyId
            , CASE WHEN TRIM (tmp.GoodsId_ReWork)           <> '' THEN TRIM (tmp.GoodsId_ReWork)           ELSE '0' END :: Integer AS GoodsId_ReWork
            , CASE WHEN TRIM (tmp.DocumentKindId)           <> '' THEN TRIM (tmp.DocumentKindId)           ELSE '0' END :: Integer AS DocumentKindId
            , CASE WHEN TRIM (tmp.GoodsKindWeighingGroupId) <> '' THEN TRIM (tmp.GoodsKindWeighingGroupId) ELSE '0' END :: Integer AS GoodsKindWeighingGroupId
            , CASE WHEN TRIM (tmp.ColorGridValue)           <> '' THEN TRIM (tmp.ColorGridValue)           ELSE '0' END :: Integer AS ColorGridValue
            , CASE WHEN tmp.MovementDescId = zc_Movement_Income() :: TVarChar
                        THEN 10
                   WHEN tmp.MovementDescId = zc_Movement_ReturnOut() :: TVarChar
                        THEN 20
                   WHEN tmp.MovementDescId = zc_Movement_Sale() :: TVarChar
                        THEN 30
                   WHEN tmp.MovementDescId = zc_Movement_ReturnIn() :: TVarChar
                        THEN 40
                   WHEN tmp.MovementDescId = zc_Movement_Send() :: TVarChar AND TRIM (tmp.GoodsId_ReWork) IN ('', '0')
                        THEN 50
                   WHEN tmp.MovementDescId = zc_Movement_Send() :: TVarChar
                        THEN 51
                   WHEN tmp.MovementDescId = zc_Movement_SendOnPrice() :: TVarChar
                        THEN 0 -- можно расчитать здесь, но не хочется его нагромождать, и резервируется 60,70
                   WHEN tmp.MovementDescId = zc_Movement_Loss() :: TVarChar
                        THEN 80
                   WHEN tmp.MovementDescId = zc_Movement_ProductionSeparate() :: TVarChar
                        THEN 90
                   WHEN tmp.MovementDescId = zc_Movement_ProductionUnion() :: TVarChar
                        THEN 100
                   WHEN tmp.MovementDescId = zc_Movement_Inventory() :: TVarChar
                        THEN 110
                   ELSE 0
              END * 1000 AS OrderById
            , CASE WHEN inIsCeh = TRUE
                        THEN tmp.isProductionIn = 'TRUE' -- для производства - в настройках
                   WHEN vbBranchId = zc_Branch_Basis() AND (Object_From.Id IS NULL OR ObjectLink_UnitFrom_Branch.ChildObjectId > 0)
                    AND tmp.MovementDescId IN (zc_Movement_SendOnPrice() :: TVarChar)
                        THEN TRUE -- для главного - приход на него
                   WHEN vbBranchId = zc_Branch_Basis()
                        THEN FALSE -- для главного - расход с него
                   WHEN vbBranchId = ObjectLink_UnitTo_Branch.ChildObjectId
                        THEN TRUE -- для филиала - приход на него
                   ELSE FALSE -- для филиала - расход с него
              END AS isSendOnPriceIn

            , CASE WHEN tmp.isPartionGoodsDate        ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isPartionGoodsDate
            , CASE WHEN tmp.isPartionDate_save        ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isPartionDate_save
            , CASE WHEN tmp.isStorageLine             ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isStorageLine
            , CASE WHEN tmp.isArticleLoss             ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isArticleLoss
            , CASE WHEN tmp.isTransport_link          ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isTransport_link
            , CASE WHEN tmp.isSubjectDoc              ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isSubjectDoc
            , CASE WHEN tmp.isComment                 ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isComment
            , CASE WHEN tmp.isInvNumberPartner        ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isInvNumberPartner
            , CASE WHEN tmp.isInvNumberPartner_check  ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isInvNumberPartner_check
            , CASE WHEN tmp.isDocPartner              ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isDocPartner
            , CASE WHEN tmp.isPersonalGroup           ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isPersonalGroup
            , CASE WHEN tmp.isOrderInternal           ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isOrderInternal
            , CASE WHEN tmp.isSticker_Ceh             ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isSticker_Ceh
            , CASE WHEN tmp.isSticker_KVK             ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isSticker_KVK
            , CASE WHEN tmp.isLockStartWeighing       ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isLockStartWeighing
            , CASE WHEN tmp.isKVK                     ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isKVK
            , CASE WHEN tmp.isListInventory           ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isListInventory
            , CASE WHEN tmp.isAsset                   ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isAsset
            , CASE WHEN tmp.isPartionCell             ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isPartionCell
            , CASE WHEN tmp.isPartionPassport         ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isPartionPassport
            , CASE WHEN tmp.isReReturnIn              ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isReReturnIn
            , CASE WHEN tmp.isCloseInventory          ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isCloseInventory
            , CASE WHEN tmp.isCalc_Sh                 ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isCalc_Sh
            , CASE WHEN tmp.isRePack                  ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isRePack
            , CASE WHEN tmp.isOperCountPartner        ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isOperCountPartner
            , CASE WHEN tmp.isOperPricePartner        ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isOperPricePartner
            , CASE WHEN tmp.isReturnOut_Date          ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isReturnOut_Date
            , CASE WHEN tmp.isCalc_PriceVat           ILIKE 'TRUE' THEN TRUE ELSE FALSE END AS isCalc_PriceVat

            , CASE WHEN tmp.MovementDescId IN (zc_Movement_ProductionUnion() :: TVarChar) AND inBranchCode BETWEEN 201 AND 210 -- если Обвалка
                        THEN 'после Шприцевания' -- 'Упаковка'
                   -- WHEN (tmp.FromId IN ('951601', '981821') OR tmp.ToId IN ('951601', '981821')) AND inBranchCode BETWEEN 201 AND 210 -- если Обвалка
                   --      THEN 'Упаковка / на Шприцевание'
                   WHEN tmp.MovementDescId IN (zc_Movement_ProductionUnion() :: TVarChar, zc_Movement_ProductionSeparate() :: TVarChar)
                        THEN 'Производство'
                   ELSE MovementDesc.ItemName
              END AS ItemName

       FROM (SELECT tmp.*
                  , CASE WHEN inIsCeh = TRUE AND vbIsSticker = FALSE AND tmp.MovementDescId = zc_Movement_Loss() :: TVarChar THEN gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isArticleLoss', 'FALSE', inSession) ELSE ''  END AS isArticleLoss
             FROM (SELECT tmp.Number
                        , gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'DescId'     ,               '0',      inSession) AS MovementDescId
                        , gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'DescId_next',               '0',      inSession) AS MovementDescId_next
                        , gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'FromId'     ,               '0',      inSession) AS FromId
                        , gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'ToId'       ,               '0',      inSession) AS ToId
                        , gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'FromId_next',               '0',      inSession) AS FromId_next
                        , gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'ToId_next'  ,               '0',      inSession) AS ToId_next
                        , gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'ColorGrid'  ,               '0',      inSession) AS ColorGridValue
                        , CASE WHEN vbIsSticker = TRUE THEN '0' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'GoodsId_ReWork' ,          '0',      inSession) END AS GoodsId_ReWork
                        , CASE WHEN vbIsSticker = TRUE THEN '0' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'GoodsKindWeighingGroupId', '345238', inSession) END AS GoodsKindWeighingGroupId -- Продажа
                        , CASE WHEN inIsCeh = TRUE                         THEN '0'     ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END     || tmp.Number, 'PaidKindId',         '0',                                                         inSession)          END AS PaidKindId
                        , CASE WHEN inIsCeh = TRUE  OR vbIsSticker = TRUE  THEN '0'     ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END     || tmp.Number, 'InfoMoneyId',        zc_Enum_InfoMoney_30101() :: TVarChar,                       inSession)          END AS InfoMoneyId -- Доходы + Продукция + Готовая продукция
                        , CASE WHEN inIsCeh = TRUE AND vbIsSticker = FALSE THEN gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END              || tmp.Number, 'DocumentKindId',     '0',                                                         inSession) ELSE '0'     END AS DocumentKindId
                        , CASE WHEN inIsCeh = TRUE AND vbIsSticker = FALSE THEN gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END              || tmp.Number, 'isProductionIn',     'TRUE',                                                      inSession) ELSE ''      END AS isProductionIn
                        , CASE WHEN inIsCeh = TRUE AND vbIsSticker = FALSE THEN gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END              || tmp.Number, 'isLockStartWeighing', CASE WHEN inBranchCode >= 201 THEN 'FALSE' ELSE 'TRUE' END, inSession) ELSE ''      END AS isLockStartWeighing

                        , CASE WHEN /*inIsCeh = TRUE AND*/ vbIsSticker = FALSE THEN gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END          || tmp.Number, 'isPartionGoodsDate', 'FALSE',                                                     inSession) ELSE ''      END AS isPartionGoodsDate
                        , CASE WHEN /*inIsCeh = TRUE AND*/ vbIsSticker = FALSE THEN gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END          || tmp.Number, 'isPartionDate_save', 'FALSE',                                                     inSession) ELSE ''      END AS isPartionDate_save

                        , CASE WHEN inIsCeh = TRUE AND vbIsSticker = FALSE THEN gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END              || tmp.Number, 'isStorageLine',      'FALSE',                                                     inSession) ELSE ''      END AS isStorageLine
                        , CASE WHEN inIsCeh = TRUE  OR vbIsSticker = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isTransport_link',   'FALSE',                                                     inSession)              END AS isTransport_link
                        , CASE WHEN                    vbIsSticker = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isSubjectDoc',       'FALSE',                                                     inSession)              END AS isSubjectDoc
                        , CASE WHEN                    vbIsSticker = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isComment',          'FALSE',                                                     inSession)              END AS isComment

                        , CASE WHEN inIsCeh = TRUE  OR vbIsSticker = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isInvNumberPartner',       'FALSE',                                               inSession)              END AS isInvNumberPartner
                        , CASE WHEN inIsCeh = TRUE  OR vbIsSticker = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isInvNumberPartner_check', 'TRUE',                                                inSession)              END AS isInvNumberPartner_check
                        , CASE WHEN inIsCeh = TRUE  OR vbIsSticker = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isDocPartner',             'FALSE',                                               inSession)              END AS isDocPartner

                        , CASE WHEN inIsCeh = FALSE OR vbIsSticker = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isPersonalGroup',    'FALSE',                                                     inSession)              END AS isPersonalGroup
                        , CASE WHEN inIsCeh = FALSE OR vbIsSticker = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isOrderInternal',    'FALSE',                                                     inSession)              END AS isOrderInternal
                        , CASE WHEN inIsCeh = FALSE OR vbIsSticker = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isSticker_Ceh',      'FALSE',                                                     inSession)              END AS isSticker_Ceh
                        , CASE WHEN inIsCeh = FALSE OR vbIsSticker = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isSticker_KVK',      'FALSE',                                                     inSession)              END AS isSticker_KVK
                        , CASE WHEN inIsCeh = FALSE OR vbIsSticker = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isKVK',              'FALSE',                                                     inSession)              END AS isKVK
                        , CASE WHEN                    vbIsSticker = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isListInventory',    'FALSE',                                                     inSession)              END AS isListInventory
                        , CASE WHEN                    vbIsSticker = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isAsset',            'FALSE',                                                     inSession)              END AS isAsset
                        , CASE WHEN                    vbIsSticker = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isPartionCell',      'FALSE',                                                     inSession)              END AS isPartionCell
                        , CASE WHEN inIsCeh = FALSE OR vbIsSticker = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isPartionPassport',  'FALSE',                                                     inSession)              END AS isPartionPassport

                        , CASE WHEN                    vbIsSticker = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isReReturnIn',       'FALSE',                                                     inSession)              END AS isReReturnIn
                        , CASE WHEN                    vbIsSticker = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isCloseInventory',   'TRUE',                                                      inSession)              END AS isCloseInventory
                        , CASE WHEN                    inIsCeh     = TRUE               THEN gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isCalc_Sh',          'FALSE',                                                     inSession) ELSE 'FALSE' END AS isCalc_Sh
                        , CASE WHEN                    inIsCeh     = TRUE               THEN gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isRePack',           'FALSE',                                                     inSession) ELSE 'FALSE' END AS isRePack

                        , CASE WHEN                    inIsCeh     = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isOperCountPartner', 'FALSE',                                                     inSession)              END AS isOperCountPartner
                        , CASE WHEN                    inIsCeh     = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isOperPricePartner', 'FALSE',                                                     inSession)              END AS isOperPricePartner
                        , CASE WHEN                    inIsCeh     = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isReturnOut_Date',   'FALSE',                                                     inSession)              END AS isReturnOut_Date
                        , CASE WHEN                    inIsCeh     = TRUE  THEN 'FALSE' ELSE gpGet_ToolsWeighing_Value (vbLevelMain, 'Movement', 'MovementDesc_' || CASE WHEN tmp.Number < 10 THEN '0' ELSE '' END || tmp.Number, 'isCalc_PriceVat',    'FALSE',                                                     inSession)              END AS isCalc_PriceVat


                   FROM (SELECT GENERATE_SERIES (1, vbCount) AS Number) AS tmp
                  ) AS tmp
            ) AS tmp
            LEFT JOIN Object AS Object_From ON Object_From.Id = CASE WHEN TRIM (tmp.FromId) <> '' THEN TRIM (tmp.FromId) ELSE '0' END :: Integer
            LEFT JOIN Object AS Object_To   ON Object_To.Id   = CASE WHEN TRIM (tmp.ToId)   <> '' THEN TRIM (tmp.ToId)   ELSE '0' END :: Integer
            LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Branch
                                 ON ObjectLink_UnitFrom_Branch.ObjectId = Object_From.Id
                                AND ObjectLink_UnitFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Branch
                                 ON ObjectLink_UnitTo_Branch.ObjectId = Object_To.Id
                                AND ObjectLink_UnitTo_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN MovementDesc ON MovementDesc.Id = CASE WHEN TRIM (tmp.MovementDescId) <> '' THEN TRIM (tmp.MovementDescId) ELSE '0' END :: Integer
      ;

    -- можно расчитать и в пред. запросе, но не хочется его нагромождать
    UPDATE _tmpToolsWeighing SET OrderById = 1000 * CASE WHEN _tmpToolsWeighing.FromId = 8411    -- Склад ГП ф.Киев
                                                          AND _tmpToolsWeighing.ToId   = 3080691 -- Склад ГП ф.Львов
                                                          AND inBranchCode = 2
                                                              THEN 71 --
                                                         WHEN _tmpToolsWeighing.FromId = 3080691 -- Склад ГП ф.Львов
                                                          AND _tmpToolsWeighing.ToId   = 8411    -- Склад ГП ф.Киев
                                                          AND inBranchCode = 2
                                                              THEN 72 --

                                                         WHEN _tmpToolsWeighing.FromId = 8411    -- Склад ГП ф.Киев
                                                          AND _tmpToolsWeighing.ToId   = 3080691 -- Склад ГП ф.Львов
                                                          AND inBranchCode = 12
                                                              THEN 73 --
                                                         WHEN _tmpToolsWeighing.FromId = 3080691 -- Склад ГП ф.Львов
                                                          AND _tmpToolsWeighing.ToId   = 8411    -- Склад ГП ф.Киев
                                                          AND inBranchCode = 12
                                                              THEN 74 --


                                                         WHEN vbBranchId = zc_Branch_Basis() AND _tmpToolsWeighing.isSendOnPriceIn = FALSE
                                                              THEN 60 -- для главного - расход с него, будет в списке раньше
                                                         WHEN vbBranchId = zc_Branch_Basis()
                                                              THEN 70 -- для главного - приход на него, будет в списке позже
                                                         WHEN _tmpToolsWeighing.isSendOnPriceIn = TRUE
                                                              THEN 60 -- для филиала - приход на него, будет в списке раньше
                                                         ELSE 70 -- для филиала - расход с него, будет в списке позже
                                                    END
                               , ItemName = CASE WHEN _tmpToolsWeighing.FromId = 8411    -- Склад ГП ф.Киев
                                                  AND _tmpToolsWeighing.ToId   = 3080691 -- Склад ГП ф.Львов
                                                  AND inBranchCode = 2
                                                      THEN 'Расход с филиала'
                                                 WHEN _tmpToolsWeighing.FromId = 3080691 -- Склад ГП ф.Львов
                                                  AND _tmpToolsWeighing.ToId   = 8411    -- Склад ГП ф.Киев
                                                  AND inBranchCode = 2
                                                      THEN 'Возврат на филиал'

                                                 WHEN _tmpToolsWeighing.FromId = 8411    -- Склад ГП ф.Киев
                                                  AND _tmpToolsWeighing.ToId   = 3080691 -- Склад ГП ф.Львов
                                                  AND inBranchCode = 12
                                                      THEN 'Приход на филиал'
                                                 WHEN _tmpToolsWeighing.FromId = 3080691 -- Склад ГП ф.Львов
                                                  AND _tmpToolsWeighing.ToId   = 8411    -- Склад ГП ф.Киев
                                                  AND inBranchCode = 12
                                                      THEN 'Возврат с филиала'

                                                 WHEN _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice()
                                                  AND _tmpToolsWeighing.isSendOnPriceIn = FALSE
                                                  AND vbBranchId = zc_Branch_Basis()
                                                      THEN 'Расход на филиал'
                                                 WHEN _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice()
                                                  AND vbBranchId = zc_Branch_Basis()
                                                      THEN 'Возврат с филиала'
                                                 WHEN _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice()
                                                  AND _tmpToolsWeighing.isSendOnPriceIn = TRUE
                                                      THEN 'Приход на филиал'
                                                 WHEN _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice()
                                                      THEN 'Возврат с филиала'
                                                 ELSE _tmpToolsWeighing.ItemName
                                            END
    WHERE _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice();


    -- Результат
    RETURN QUERY
      WITH tmpReason AS (SELECT MAX (CASE WHEN ObjectBoolean_ReturnIn.ValueData = TRUE THEN Object_Reason.Id ELSE 0 END) AS ReasonId_ReturnIn
                              , MAX (CASE WHEN ObjectBoolean_SendOnPrice.ValueData = TRUE THEN Object_Reason.Id ELSE 0 END) AS ReasonId_SendOnPrice
                         FROM Object AS Object_Reason
                              LEFT JOIN ObjectBoolean AS ObjectBoolean_ReturnIn
                                                      ON ObjectBoolean_ReturnIn.ObjectId = Object_Reason.Id
                                                     AND ObjectBoolean_ReturnIn.DescId = zc_ObjectBoolean_Reason_ReturnIn()
                              LEFT JOIN ObjectBoolean AS ObjectBoolean_SendOnPrice
                                                      ON ObjectBoolean_SendOnPrice.ObjectId = Object_Reason.Id
                                                     AND ObjectBoolean_SendOnPrice.DescId = zc_ObjectBoolean_Reason_SendOnPrice()
                         WHERE Object_Reason.DescId   = zc_Object_Reason()
                           AND Object_Reason.isErased = FALSE
                           AND (ObjectBoolean_ReturnIn.ValueData = TRUE
                             OR ObjectBoolean_SendOnPrice.ValueData = TRUE
                               )
                        )
      --
      SELECT _tmpToolsWeighing.Number                        AS Number
           , _tmpToolsWeighing.MovementDescId                AS MovementDescId
           , _tmpToolsWeighing.MovementDescId_next           AS MovementDescId_next

           , COALESCE (Object_From.Id, 0) :: Integer         AS FromId
           , Object_From.ObjectCode                          AS FromCode
           , Object_From.ValueData                           AS FromName
           , COALESCE (Object_To.Id, 0) :: Integer           AS ToId
           , Object_To.ObjectCode                            AS ToCode
           , Object_To.ValueData                             AS ToName

           , COALESCE (Object_From_next.Id, 0) :: Integer    AS FromId_next
           , Object_From_next.ObjectCode                     AS FromCode_next
           , Object_From_next.ValueData                      AS FromName_next
           , COALESCE (Object_To_next.Id, 0)   :: Integer    AS ToId_next
           , Object_To_next.ObjectCode                       AS ToCode_next
           , Object_To_next.ValueData                        AS ToName_next

           , Object_PaidKind.Id                              AS PaidKindId
           , Object_PaidKind.ValueData                       AS PaidKindName
           , COALESCE (Object_InfoMoney.Id, 0) :: Integer    AS InfoMoneyId
           , Object_InfoMoney.ObjectCode                     AS InfoMoneyCode
           , Object_InfoMoney.ValueData                      AS InfoMoneyName
           , Object_PriceList.Id                             AS PriceListId
           , Object_PriceList.ObjectCode                     AS PriceListCode
           , Object_PriceList.ValueData                      AS PriceListName

           , _tmpToolsWeighing.GoodsId_ReWork                AS GoodsId_ReWork
           , Object_GoodsReWork.ObjectCode                   AS GoodsCode_ReWork
           , Object_GoodsReWork.ValueData                    AS GoodsName_ReWork

            , _tmpToolsWeighing.DocumentKindId               AS DocumentKindId
            , Object_DocumentKind.ValueData                  AS DocumentKindName

            , Object_Reason.Id                               AS ReasonId
            , Object_Reason.ObjectCode                       AS ReasonCode
            , Object_Reason.ValueData                        AS ReasonName
            , Object_ReturnKind.ValueData                    AS ReturnKindName

           , Object_GoodsKindWeighingGroup.Id                AS GoodsKindWeighingGroupId
           , _tmpToolsWeighing.ColorGridValue                AS ColorGridValue

           , ('(' || _tmpToolsWeighing.Number :: TVarChar ||') '
          || CASE WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut())
                       THEN COALESCE (Object_From.ValueData, '') || ' => ' || COALESCE (Object_PaidKind.ValueData, '')

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Income()) AND _tmpToolsWeighing.isDocPartner = TRUE
                       THEN COALESCE (Object_PaidKind.ValueData, '') || ' => Накладная Поставщика' 

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_Income())
                       THEN COALESCE (Object_PaidKind.ValueData, '') || ' => ' || COALESCE (Object_To.ValueData, '')
                         || CASE WHEN _tmpToolsWeighing.MovementDescId_next > 0
                                     THEN ' => ' || COALESCE (Object_To_next.ValueData, '') || ' (перемещение)'
                                 ELSE ''
                            END

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice())
                       THEN COALESCE (Object_From.ValueData, '') || ' => ' || COALESCE (Object_To.ValueData, '')

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Loss())
                       THEN COALESCE (Object_From.ValueData, '') || ' => ' || CASE WHEN Object_To.Id > 0 THEN ' ' || COALESCE (Object_To.ValueData, '') ELSE '' END

                  WHEN _tmpToolsWeighing.GoodsId_ReWork > 0 -- !!!вроде нет, т.к. есть в конце!!!
                       THEN '(' || Object_GoodsReWork.ObjectCode :: TVarChar || ')' || Object_GoodsReWork.ValueData

                  WHEN _tmpToolsWeighing.DocumentKindId > 0 AND 1=0 -- !!!нет, т.к. есть в конце!!!
                       THEN '(' || Object_DocumentKind.ValueData || ')'

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                       THEN CASE WHEN _tmpToolsWeighing.DocumentKindId > 0 AND 1=0 -- !!!нет, т.к. есть в конце!!!
                                      THEN '(' || Object_DocumentKind.ValueData || ')'
                                 WHEN _tmpToolsWeighing.GoodsId_ReWork > 0 -- !!!вроде нет, т.к. есть в конце!!!
                                      THEN '(' || Object_GoodsReWork.ObjectCode :: TVarChar || ')' || Object_GoodsReWork.ValueData
                                 WHEN _tmpToolsWeighing.isSendOnPriceIn = TRUE
                                      THEN 'ПРИХОД'
                                 ELSE 'РАCХОД'
                            END
                  || ' ' || COALESCE (Object_From.ValueData, '') || ' => ' || COALESCE (Object_To.ValueData, '')

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Inventory()) AND COALESCE (Object_From.ValueData, '') = COALESCE (Object_To.ValueData, '')
                      THEN COALESCE (Object_From.ValueData, '')

                  ELSE TRIM (COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, ''))
              END
           || CASE WHEN _tmpToolsWeighing.GoodsId_ReWork > 0
                        THEN ' = > (' || Object_GoodsReWork.ObjectCode :: TVarChar || ')' || Object_GoodsReWork.ValueData
                   ELSE ''
              END
           || CASE WHEN _tmpToolsWeighing.DocumentKindId > 0
                        THEN ' = > (' || Object_DocumentKind.ValueData || ')'
                   ELSE ''
              END
          || CASE WHEN _tmpToolsWeighing.isRePack = TRUE
                       THEN '  (ПЕРЕПАК)'
                  ELSE ''
             END
             ) :: TVarChar AS MovementDescName -- в гриде

           , ('(' || _tmpToolsWeighing.Number :: TVarChar ||') '
          || _tmpToolsWeighing.ItemName -- MovementDesc.ItemName
          || ': '
          || CASE WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut())
                       THEN COALESCE (Object_From.ValueData, '') || ' => ' || COALESCE (Object_PaidKind.ValueData, '')

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_Income())
                       THEN COALESCE (Object_PaidKind.ValueData, '') || ' => ' || COALESCE (Object_To.ValueData, '')
                         || CASE WHEN _tmpToolsWeighing.MovementDescId_next > 0
                                     THEN ' => ' || COALESCE (Object_To_next.ValueData, '') || ' (перемещение)'
                                 ELSE ''
                            END

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendOnPrice())
                       THEN COALESCE (Object_From.ValueData, '') || ' => ' || COALESCE (Object_To.ValueData, '')

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Loss())
                       THEN COALESCE (Object_From.ValueData, '') || ' => ' || CASE WHEN Object_To.Id > 0 THEN ' ' || COALESCE (Object_To.ValueData, '') ELSE '' END

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate())
                       THEN CASE WHEN _tmpToolsWeighing.isSendOnPriceIn = TRUE
                                      THEN 'ПРИХОД'
                                 ELSE 'РАCХОД'
                            END
                  || ' ' || COALESCE (Object_From.ValueData, '') || ' => ' || COALESCE (Object_To.ValueData, '')

                  WHEN _tmpToolsWeighing.MovementDescId IN (zc_Movement_Inventory()) AND COALESCE (Object_From.ValueData, '') = COALESCE (Object_To.ValueData, '')
                      THEN COALESCE (Object_From.ValueData, '')

                  ELSE TRIM (COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, ''))
             END

          || CASE WHEN _tmpToolsWeighing.GoodsId_ReWork > 0
                       THEN ' = > (' || Object_GoodsReWork.ObjectCode :: TVarChar || ')' || Object_GoodsReWork.ValueData
                  ELSE ''
             END
          || CASE WHEN _tmpToolsWeighing.DocumentKindId > 0
                       THEN ' = > (' || Object_DocumentKind.ValueData || ')'
                  ELSE ''
             END
          || CASE WHEN EXISTS (SELECT 1 FROM _tmpToolsWeighing WHERE _tmpToolsWeighing.MovementDescId = zc_Movement_Inventory() AND _tmpToolsWeighing.isListInventory = TRUE)
                       THEN '  (выборочная для списка товаров)'
                  ELSE ''
             END
          || CASE WHEN _tmpToolsWeighing.isRePack = TRUE
                       THEN '  (ПЕРЕПАК)'
                  ELSE ''
             END
          || CASE WHEN inBranchCode = 115
                       THEN '  (ПОДГОТОВКА)'
                  ELSE ''
             END
            ) :: TVarChar AS MovementDescName_master

           , MovementDesc_next.ItemName AS MovementDescName_next

           , (_tmpToolsWeighing.OrderById + _tmpToolsWeighing.Number) :: Integer AS OrderById
           , _tmpToolsWeighing.isSendOnPriceIn
           , _tmpToolsWeighing.isPartionGoodsDate
           , _tmpToolsWeighing.isPartionDate_save
           , _tmpToolsWeighing.isStorageLine
           , _tmpToolsWeighing.isArticleLoss
           , _tmpToolsWeighing.isTransport_link
           , _tmpToolsWeighing.isSubjectDoc
           , _tmpToolsWeighing.isComment
           , _tmpToolsWeighing.isInvNumberPartner
           , _tmpToolsWeighing.isInvNumberPartner_check
           , _tmpToolsWeighing.isDocPartner

           , _tmpToolsWeighing.isPersonalGroup
           , _tmpToolsWeighing.isOrderInternal
           , _tmpToolsWeighing.isSticker_Ceh
           , _tmpToolsWeighing.isSticker_KVK
           , _tmpToolsWeighing.isLockStartWeighing
           , _tmpToolsWeighing.isKVK
           , _tmpToolsWeighing.isListInventory
           , _tmpToolsWeighing.isAsset
           , _tmpToolsWeighing.isPartionCell
           , _tmpToolsWeighing.isPartionPassport
           , _tmpToolsWeighing.isReReturnIn
           , _tmpToolsWeighing.isCloseInventory
           , _tmpToolsWeighing.isCalc_Sh
           , _tmpToolsWeighing.isRePack
           , _tmpToolsWeighing.isOperCountPartner
           , _tmpToolsWeighing.isOperPricePartner
           , _tmpToolsWeighing.isReturnOut_Date
           , _tmpToolsWeighing.isCalc_PriceVat

       FROM _tmpToolsWeighing
            LEFT JOIN Object AS Object_PriceList              ON Object_PriceList.Id              = zc_PriceList_Basis() AND _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice()
            LEFT JOIN Object AS Object_From                   ON Object_From.Id                   = _tmpToolsWeighing.FromId
            LEFT JOIN Object AS Object_To                     ON Object_To.Id                     = _tmpToolsWeighing.ToId
            LEFT JOIN Object AS Object_From_next              ON Object_From_next.Id              = _tmpToolsWeighing.FromId_next
            LEFT JOIN Object AS Object_To_next                ON Object_To_next.Id                = _tmpToolsWeighing.ToId_next
            LEFT JOIN Object AS Object_PaidKind               ON Object_PaidKind.Id               = _tmpToolsWeighing.PaidKindId
            LEFT JOIN Object AS Object_InfoMoney              ON Object_InfoMoney.Id              = _tmpToolsWeighing.InfoMoneyId
            LEFT JOIN Object AS Object_GoodsReWork            ON Object_GoodsReWork.Id            = _tmpToolsWeighing.GoodsId_ReWork
            LEFT JOIN Object AS Object_DocumentKind           ON Object_DocumentKind.Id           = _tmpToolsWeighing.DocumentKindId
            LEFT JOIN Object AS Object_GoodsKindWeighingGroup ON Object_GoodsKindWeighingGroup.Id = _tmpToolsWeighing.GoodsKindWeighingGroupId
            LEFT JOIN MovementDesc AS MovementDesc_next ON MovementDesc_next.Id = _tmpToolsWeighing.MovementDescId_next
            LEFT JOIN tmpReason ON _tmpToolsWeighing.MovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_SendOnPrice())
            LEFT JOIN Object AS Object_Reason ON Object_Reason.Id = CASE WHEN _tmpToolsWeighing.MovementDescId = zc_Movement_ReturnIn() THEN tmpReason.ReasonId_ReturnIn
                                                                         WHEN _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice() THEN tmpReason.ReasonId_SendOnPrice
                                                                         ELSE 0
                                                                    END
            LEFT JOIN ObjectLink AS ObjectLink_ReturnKind
                                 ON ObjectLink_ReturnKind.ObjectId = Object_Reason.Id
                                AND ObjectLink_ReturnKind.DescId   = zc_ObjectLink_Reason_ReturnKind()
            LEFT JOIN Object AS Object_ReturnKind ON Object_ReturnKind.Id = ObjectLink_ReturnKind.ChildObjectId

       WHERE _tmpToolsWeighing.MovementDescId > 0
      --AND (_tmpToolsWeighing.Number < 71 OR vbUserId = 5 OR inBranchCode <> 201 OR inIsCeh = TRUE)
         -- AND (_tmpToolsWeighing.isDocPartner = FALSE OR vbUserId in (5, 6604558))
         -- Голота К.О.
         --AND (_tmpToolsWeighing.Number <> 80 OR vbUserId IN (5, 6604558) OR inBranchCode <> 201)
         AND (_tmpToolsWeighing.Number <> 42 OR vbUserId IN (5, 6604558) OR inBranchCode <> 301)

      UNION
       -- это группы
       SELECT 0                                   AS Number
            ,(CASE WHEN tmp.isReWork = TRUE THEN -100 * tmp.MovementDescId ELSE -1 * tmp.MovementDescId END) :: Integer AS MovementDescId
            , 0  :: Integer                       AS MovementDescId_next
            , 0                                   AS FromId
            , 0                                   AS FromCode
            , '' :: TVarChar                      AS FromName
            , 0                                   AS ToId
            , 0                                   AS ToCode
            , '' :: TVarChar                      AS ToName
            , 0                                   AS FromId_next
            , 0                                   AS FromCode_next
            , '' :: TVarChar                      AS FromName_next
            , 0                                   AS ToId_next
            , 0                                   AS ToCode_next
            , '' :: TVarChar                      AS ToName_next

            , 0                                   AS PaidKindId
            , '' :: TVarChar                      AS PaidKindName
            , 0                                   AS InfoMoneyId
            , 0                                   AS InfoMoneyCode
            , '' :: TVarChar                      AS InfoMoneyName
            , 0                                   AS PriceListId
            , 0                                   AS PriceListCode
            , '' :: TVarChar                      AS PriceListName
            , 0                                   AS GoodsId_ReWork
            , 0                                   AS GoodsCode_ReWork
            , '' :: TVarChar                      AS GoodsName_ReWork
            , 0                                   AS DocumentKindId
            , '' :: TVarChar                      AS DocumentKindName
            , 0                                   AS ReasonId
            , 0                                   AS ReasonCode
            , '' :: TVarChar                      AS ReasonName
            , '' :: TVarChar                      AS ReturnKindName
            , 0                                   AS GoodsKindWeighingGroupId
            , 0                                   AS ColorGridValue
            , CASE WHEN tmp.isReWork        = TRUE AND inBranchCode BETWEEN 201 AND 203
                        THEN 'ПЕРЕСОРТЫ'

                   WHEN tmp.isReWork        = TRUE
                        THEN 'ПЕРЕРАБОТКА'

                   WHEN tmp.OrderById = 71000
                        THEN 'Расход с филиала'
                   WHEN tmp.OrderById = 72000
                        THEN 'Возврат на филиал'
                   WHEN tmp.OrderById = 73000
                        THEN 'Приход на филиал'
                   WHEN tmp.OrderById = 74000
                        THEN 'Возврат с филиала'

                   WHEN tmp.MovementDescId = zc_Movement_SendOnPrice()
                    AND tmp.isSendOnPriceIn = FALSE
                    AND vbBranchId = zc_Branch_Basis()
                        THEN 'Расход на филиал'
                   WHEN tmp.MovementDescId = zc_Movement_SendOnPrice()
                    AND vbBranchId = zc_Branch_Basis()
                        THEN 'Возврат с филиала'
                   WHEN tmp.MovementDescId = zc_Movement_SendOnPrice()
                    AND tmp.isSendOnPriceIn = TRUE
                        THEN 'Приход на филиал'
                   WHEN tmp.MovementDescId = zc_Movement_SendOnPrice()
                        THEN 'Возврат с филиала'


                   ELSE tmp.ItemName -- MovementDesc.ItemName
                     || CASE WHEN EXISTS (SELECT 1 FROM _tmpToolsWeighing WHERE _tmpToolsWeighing.MovementDescId = zc_Movement_Inventory() AND _tmpToolsWeighing.isListInventory = TRUE)
                                  THEN '  (выборочная для списка товаров)'
                             ELSE ''
                        END

                     || CASE WHEN inBranchCode = 115
                                  THEN '  (ПОДГОТОВКА)'
                             ELSE ''
                        END

              END :: TVarChar AS MovementDescName
            , '' :: TVarChar                      AS MovementDescName_master
            , '' :: TVarChar                      AS MovementDescName_next
            , tmp.OrderById                       AS OrderById
            , tmp.isSendOnPriceIn
            , FALSE AS isPartionGoodsDate
            , FALSE AS isPartionDate_save
            , FALSE AS isStorageLine
            , FALSE AS isArticleLoss
            , FALSE AS isTransport_link
            , FALSE AS isSubjectDoc
            , FALSE AS isComment
            , FALSE AS isInvNumberPartner
            , FALSE AS isInvNumberPartner_check
            , FALSE AS isDocPartner
            , FALSE AS isPersonalGroup
            , FALSE AS isOrderInternal
            , FALSE AS isSticker_Ceh
            , FALSE AS isSticker_KVK
            , FALSE AS isLockStartWeighing
            , FALSE AS isKVK
            , FALSE AS isListInventory
            , FALSE AS isAsset
            , FALSE AS isPartionCell
            , FALSE AS isPartionPassport
            , FALSE AS isReReturnIn
            , FALSE AS isCloseInventory
            , FALSE AS isCalc_Sh
            , FALSE AS isRePack
            , FALSE AS isOperCountPartner
            , FALSE AS isOperPricePartner
            , FALSE AS isReturnOut_Date
            , FALSE AS isCalc_PriceVat

       FROM (SELECT DISTINCT
                    _tmpToolsWeighing.MovementDescId
                  , _tmpToolsWeighing.OrderById
                  , CASE WHEN _tmpToolsWeighing.MovementDescId = zc_Movement_SendOnPrice() OR _tmpToolsWeighing.GoodsId_ReWork > 0 THEN _tmpToolsWeighing.isSendOnPriceIn ELSE FALSE END AS isSendOnPriceIn
                  , CASE WHEN _tmpToolsWeighing.GoodsId_ReWork > 0 THEN TRUE ELSE FALSE END AS isReWork
                  , _tmpToolsWeighing.ItemName
             FROM _tmpToolsWeighing
             WHERE _tmpToolsWeighing.MovementDescId > 0
            ) AS tmp
            -- LEFT JOIN MovementDesc ON MovementDesc.Id = tmp.MovementDescId
      ORDER BY OrderById;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.01.15                                        * all
 20.03.14                                                         *
 14.03.14                                                         *
*/
/*
--  update Object set ValueData = xx.ValueData
-- from (
 select a.Id, a.ValueData
, b.Id as Id2, b.ValueData as ValueData2
-- , a.*
from gpSelect_Object_ToolsWeighing (inSession := '5') as a
 join (select * from gpSelect_Object_ToolsWeighing (inSession := '5') as x where (x.namefull  ilike '%ScaleCeh_202%') )as b
 on b.namefull   ilike  zfCalc_Text_replace (a.namefull , 'ScaleCeh_201', 'ScaleCeh_202')
where (a.namefull  ilike '%ScaleCeh_201%')
-- and b.namefull  is null
and b.ValueData = a.ValueData
--) as xx where xx.Id2 = Object.Id
*/
-- тест
-- SELECT * FROM gpSelect_Object_ToolsWeighing_MovementDesc (TRUE, 201, zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_ToolsWeighing_MovementDesc (FALSE, 301, zfCalc_UserAdmin())
