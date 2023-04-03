-- Function: gpGet_Scale_OrderExternal()

-- DROP FUNCTION IF EXISTS gpGet_Scale_OrderExternal (TDateTime, Integer, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpGet_Scale_OrderExternal (TDateTime, Integer, Integer, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpGet_Scale_OrderExternal (Boolean, TDateTime, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Scale_OrderExternal (Boolean, TDateTime, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_OrderExternal(
    IN inIsCeh          Boolean   , -- программа ScaleCeh - да/нет
    IN inOperDate       TDateTime   ,
    IN inFromId         Integer   , --
    IN inToId           Integer   , --
    IN inBranchCode     Integer   , --
    IN inBarCode        TVarChar    ,
    IN inSession        TVarChar      -- сессия пользователя
)
RETURNS TABLE (MovementId            Integer
             , MovementDescId_order  Integer
             , MovementId_get        Integer -- документ взвешивания !!!только для заявки!!!, потом переносится в MovementId
             , BarCode               TVarChar
             , InvNumber             TVarChar
             , InvNumberPartner      TVarChar

             , MovementDescNumber Integer -- !!!только для zc_Movement_SendOnPrice!!!
             , MovementDescId     Integer -- !!!расчет для будущего документа!!!
             , FromId         Integer, FromCode         Integer, FromName       TVarChar
             , ToId           Integer, ToCode           Integer, ToName         TVarChar
             , PaidKindId     Integer, PaidKindName   TVarChar

             , PriceListId     Integer, PriceListCode     Integer, PriceListName     TVarChar
             , ContractId      Integer, ContractCode      Integer, ContractNumber    TVarChar, ContractTagName TVarChar
             , GoodsPropertyId Integer, GoodsPropertyCode Integer, GoodsPropertyName TVarChar

             , PartnerId_calc   Integer
             , PartnerCode_calc Integer
             , PartnerName_calc TVarChar
             , ChangePercent    TFloat
             , ChangePercentAmount TFloat

             , isEdiOrdspr      Boolean
             , isEdiInvoice     Boolean
             , isEdiDesadv      Boolean

             , isMovement      Boolean, CountMovement   TFloat   -- Накладная
             , isAccount       Boolean, CountAccount    TFloat   -- Счет
             , isTransport     Boolean, CountTransport  TFloat   -- ТТН
             , isQuality       Boolean, CountQuality    TFloat   -- Качественное
             , isPack          Boolean, CountPack       TFloat   -- Упаковочный
             , isSpec          Boolean, CountSpec       TFloat   -- Спецификация
             , isTax           Boolean, CountTax        TFloat   -- Налоговая

             , isContractGoods Boolean

             , OrderExternalName_master TVarChar
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbBranchId   Integer;
   DECLARE vbOperDate_Begin1 TDateTime;
   DECLARE vbMovementId_BarCode Integer;
   DECLARE vbInvNumber_BarCode  TVarChar;
BEGIN
   -- сразу запомнили время начала выполнения Проц.
   vbOperDate_Begin1:= CLOCK_TIMESTAMP();

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);


    -- Проверка
    IF (vbBranchId :: Integer) > 1000
    THEN
        RAISE EXCEPTION 'Ошибка.Для печати этикетки сканировать нельзя.';
    END IF;

    -- определяется
    vbBranchId:= CASE WHEN inBranchCode > 100 THEN zc_Branch_Basis()
                      ELSE (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inBranchCode and Object.DescId = zc_Object_Branch())
                 END;
    -- определяется
    vbMovementId_BarCode:= (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId WHERE CHAR_LENGTH (inBarCode) >= 13);
    -- определяется
    vbInvNumber_BarCode:= (SELECT inBarCode AS BarCode WHERE CHAR_LENGTH (inBarCode) > 0 AND CHAR_LENGTH (inBarCode) < 13);


    -- список
    CREATE TEMP TABLE _tmpMovement_find_all ON COMMIT DROP
                              AS (-- по Ш/К
                                  SELECT Movement.Id
                                       , Movement.InvNumber
                                       , Movement.DescId
                                       , Movement.OperDate
                                       , Movement.StatusId
                                  FROM Movement
                                  WHERE Movement.Id = vbMovementId_BarCode
                                    AND Movement.DescId IN (zc_Movement_OrderExternal(), zc_Movement_OrderInternal(), zc_Movement_SendOnPrice(), zc_Movement_ReturnIn())
                                    AND Movement.OperDate BETWEEN inOperDate - INTERVAL '18 DAY' AND inOperDate + INTERVAL '8 DAY'
                                 -- AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 UNION
                                  -- по Ш/К - Приход, т.к. период 80 дней
                                  SELECT Movement.Id
                                       , Movement.InvNumber
                                       , Movement.DescId
                                       , Movement.OperDate
                                       , Movement.StatusId
                                  FROM Movement
                                  WHERE Movement.Id = vbMovementId_BarCode
                                    AND Movement.DescId = zc_Movement_OrderIncome()
                                    AND Movement.OperDate BETWEEN inOperDate - INTERVAL '80 DAY' AND inOperDate + INTERVAL '80 DAY'
                                  --AND Movement.StatusId <> zc_Enum_Status_Erased()
                                    AND inBranchCode BETWEEN 301 AND 310
                                 UNION
                                  -- 1.1. по № документа
                                  SELECT Movement.Id
                                       , Movement.InvNumber
                                       , Movement.DescId
                                       , Movement.OperDate
                                       , Movement.StatusId
                                  FROM Movement 
                                       LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                                             AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                  WHERE inBranchCode NOT BETWEEN 201 AND 210
                                    AND Movement.InvNumber = vbInvNumber_BarCode
                                    AND Movement.DescId IN (zc_Movement_OrderExternal(), zc_Movement_OrderInternal(), zc_Movement_SendOnPrice(), zc_Movement_ReturnIn())
                                    AND Movement.OperDate BETWEEN inOperDate - INTERVAL '18 DAY' AND inOperDate + INTERVAL '8 DAY'
                                  --AND Movement.StatusId <> zc_Enum_Status_Erased()
                                    AND vbInvNumber_BarCode <> ''

                                 UNION
                                  -- 1.2. по № документа
                                  SELECT Movement.Id
                                       , Movement.InvNumber
                                       , Movement.DescId
                                       , Movement.OperDate
                                       , Movement.StatusId
                                  FROM Movement 
                                       LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                                             AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                  WHERE inBranchCode BETWEEN 201 AND 210
                                    AND MLO_To.ObjectId = 133049 -- Склад реализации мясо
                                    AND Movement.InvNumber = vbInvNumber_BarCode
                                    AND Movement.DescId IN (zc_Movement_OrderExternal(), zc_Movement_OrderInternal())
                                    AND Movement.OperDate BETWEEN inOperDate - INTERVAL '18 DAY' AND inOperDate + INTERVAL '8 DAY'
                                  --AND Movement.StatusId <> zc_Enum_Status_Erased()
                                    AND vbInvNumber_BarCode <> ''

                                 UNION
                                  -- по № документа - Приход, т.к. период 80 дней
                                  SELECT Movement.Id
                                       , Movement.InvNumber
                                       , Movement.DescId
                                       , Movement.OperDate
                                       , Movement.StatusId
                                  FROM Movement 
                                  WHERE inBranchCode BETWEEN 301 AND 310
                                    AND Movement.InvNumber = vbInvNumber_BarCode
                                    AND Movement.DescId = zc_Movement_OrderIncome()
                                    AND Movement.OperDate BETWEEN inOperDate - INTERVAL '80 DAY' AND inOperDate + INTERVAL '80 DAY'
                                  --AND Movement.StatusId <> zc_Enum_Status_Erased()
                                    AND vbInvNumber_BarCode <> ''
                                 );

    -- DELETE
    IF EXISTS (SELECT 1 FROM _tmpMovement_find_all AS tmp WHERE tmp.StatusId = zc_Enum_Status_Erased())
       AND EXISTS (SELECT 1 FROM _tmpMovement_find_all AS tmp WHERE tmp.StatusId <> zc_Enum_Status_Erased())
    THEN
         DELETE FROM _tmpMovement_find_all WHERE _tmpMovement_find_all.StatusId = zc_Enum_Status_Erased();
    END IF;

    -- ANALYZE
    ANALYZE _tmpMovement_find_all;


    -- Проверка
    IF EXISTS (SELECT 1 FROM _tmpMovement_find_all AS tmp WHERE tmp.StatusId = zc_Enum_Status_Erased() AND tmp.DescId <> zc_Movement_ReturnIn())
    THEN
        RAISE EXCEPTION 'Ошибка.Документ № <%> от <%> удален.'
                      , (SELECT tmp.InvNumber FROM _tmpMovement_find_all AS tmp WHERE tmp.StatusId = zc_Enum_Status_Erased() ORDER BY tmp.Id LIMIT 1)
                      , zfConvert_DateToString ((SELECT tmp.OperDate FROM _tmpMovement_find_all AS tmp WHERE tmp.StatusId = zc_Enum_Status_Erased() ORDER BY tmp.Id LIMIT 1))
                       ;
    END IF;

    -- Проверка
    IF inBranchCode < 100
       AND EXISTS (WITH tmpUnit_Branch AS (SELECT OL.ObjectId AS UnitId
                                           FROM ObjectLink AS OL
                                           WHERE OL.ChildObjectId = vbBranchId
                                             AND OL.DescId        = zc_ObjectLink_Unit_Branch()
                                          UNION
                                           -- Склады
                                           SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8453) AS lfSelect
                                           WHERE vbBranchId = zc_Branch_Basis()
                                          UNION
                                           -- Склады
                                           SELECT OL.ObjectId AS UnitId
                                           FROM ObjectLink AS OL
                                           WHERE OL.ChildObjectId = 8377 -- филиал Кр.Рог
                                             AND OL.DescId        = zc_ObjectLink_Unit_Branch()
                                             AND vbBranchId       = zc_Branch_Basis()
                                          )
                   SELECT 1
                   FROM _tmpMovement_find_all AS tmp
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                     ON MovementLinkObject_From.MovementId = tmp.Id
                                                    AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                     ON MovementLinkObject_To.MovementId = tmp.Id
                                                    AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                        LEFT JOIN tmpUnit_Branch AS tmpUnit_Branch_From ON tmpUnit_Branch_From.UnitId = MovementLinkObject_From.ObjectId
                        LEFT JOIN tmpUnit_Branch AS tmpUnit_Branch_To   ON tmpUnit_Branch_To.UnitId   = MovementLinkObject_To.ObjectId
                   WHERE tmpUnit_Branch_From.UnitId IS NULL AND tmpUnit_Branch_To.UnitId IS NULL
                  )
    THEN
        RAISE EXCEPTION 'Ошибка.В документ № <%> от <%> неправильно указан склад = <%>.'
                      , (SELECT tmp.InvNumber FROM _tmpMovement_find_all AS tmp ORDER BY tmp.Id LIMIT 1)
                      , zfConvert_DateToString    ((SELECT tmp.OperDate FROM _tmpMovement_find_all AS tmp ORDER BY tmp.Id LIMIT 1))
                      , lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId FROM _tmpMovement_find_all AS tmp LEFT JOIN MovementLinkObject AS MLO ON MLO.MovementId = tmp.Id AND MLO.DescId = zc_MovementLinkObject_To() ORDER BY tmp.Id LIMIT 1))
                       ;
    END IF;

    -- Результат
    RETURN QUERY
       WITH tmpUnit_Branch AS (SELECT OL.ObjectId AS UnitId
                               FROM ObjectLink AS OL
                               WHERE OL.ChildObjectId = vbBranchId
                                 AND OL.DescId        = zc_ObjectLink_Unit_Branch()
                              UNION
                               -- Склады
                               SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8453) AS lfSelect
                               WHERE vbBranchId = zc_Branch_Basis()
                            /*UNION
                               -- Склады
                               SELECT DISTINCT
                                      OL.ObjectId AS UnitId
                               FROM ObjectLink AS OL
                                    JOIN _tmpMovement_find_all ON _tmpMovement_find_all.DescId = zc_Movement_ReturnIn()
                               WHERE OL.ChildObjectId = 8377 -- филиал Кр.Рог
                                 AND OL.DescId        = zc_ObjectLink_Unit_Branch()
                                 AND vbBranchId       = zc_Branch_Basis()*/
                              )
          , tmpMovement AS (SELECT tmpMovement.Id
                                 , tmpMovement.InvNumber
                                 , tmpMovement.DescId
                                 , tmpMovement.OperDate

                                 , Object_From.DescId     AS DescId_From
                                 , Object_From.ObjectCode AS FromCode
                                 , Object_From.ValueData  AS FromName

                                 , Object_To.DescId       AS DescId_To
                                 , Object_To.ObjectCode   AS ToCode
                                 , Object_To.ValueData    AS ToName

                                   -- ContractId
                                 , MovementLinkObject_Contract.ObjectId AS ContractId

                                   -- От кого
                                 , CASE -- Для заявки поставщику
                                        WHEN tmpMovement.DescId = zc_Movement_OrderIncome()

                                             THEN MovementLinkObject_Unit.ObjectId

                                        -- Для Мясного сырья - замена
                                        WHEN tmpMovement.DescId = zc_Movement_OrderInternal()
                                          AND inBranchCode BETWEEN 201 AND 210
                                             THEN inToId

                                        -- Для остальных - Заявка покупателя или SendOnPrice или ReturnIn
                                        ELSE MovementLinkObject_From.ObjectId

                                   END AS FromId

                                   -- Кому
                                 , CASE -- Для заявки поставщику
                                        WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                                             THEN (SELECT OL.ObjectId
                                                   FROM MovementLinkObject AS MLO
                                                        INNER JOIN ObjectLink AS OL ON OL.ChildObjectId = MLO.ObjectId AND OL.DescId = zc_ObjectLink_Partner_Juridical()
                                                        INNER JOIN Object ON Object.Id = OL.ObjectId AND Object.isErased = FALSE
                                                   WHERE MLO.MovementId = tmpMovement.Id
                                                     AND MLO.DescId     = zc_MovementLinkObject_Juridical()
                                                   LIMIT 1)

                                        -- Для Мясного сырья - замена
                                        WHEN tmpMovement.DescId = zc_Movement_OrderInternal()
                                         AND inBranchCode BETWEEN 201 AND 210
                                             THEN inFromId

                                        -- Для Склад специй + Склад запчастей
                                        WHEN MovementLinkObject_From.ObjectId = MovementLinkObject_To.ObjectId
                                         AND inBranchCode BETWEEN 301 AND 310
                                         AND tmpMovement.DescId = zc_Movement_OrderInternal()
                                             THEN 8455 -- Склад специй

                                        -- Для Кр.Рог
                                        WHEN ObjectLink_UnitTo_Branch.ChildObjectId = 8377 -- филиал Кр.Рог
                                         AND vbBranchId                             = zc_Branch_Basis()
                                             THEN 8461 -- Склад Возвратов

                                        -- Для остальных - Заявка покупателя или SendOnPrice или ReturnIn
                                        ELSE MovementLinkObject_To.ObjectId

                                   END AS ToId

                                   -- JuridicalId
                                 , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                   -- GoodsPropertyId
                                 , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, ObjectLink_Partner_Juridical.ChildObjectId, ObjectLink_Partner_Juridical.ObjectId) AS GoodsPropertyId

                                   -- вот таким сложным CASE определяется приход или расход
                                 , CASE -- для всех - расход с него !!!блокируется!!!
                                        WHEN tmpUnit_Branch_From.UnitId > 0
                                         AND tmpMovement.DescId IN (zc_Movement_OrderExternal(), zc_Movement_SendOnPrice())
                                             THEN NULL

                                        -- для всех - заявка на него
                                        WHEN tmpUnit_Branch_To.UnitId > 0
                                         AND tmpMovement.DescId = zc_Movement_OrderExternal()
                                             THEN FALSE -- будет расход с него

                                        -- для всех - SendOnPrice на него
                                        WHEN tmpUnit_Branch_To.UnitId > 0
                                         AND tmpMovement.DescId = zc_Movement_SendOnPrice()
                                             THEN TRUE -- будет приход на него

                                        /*WHEN MovementLinkObject_From.ObjectId = 3080691 -- Склад ГП ф.Львов
                                         AND MovementLinkObject_To.ObjectId   = 8411    -- Склад ГП ф.Киев
                                         AND tmpMovement.DescId = zc_Movement_OrderInternal()
                                             THEN FALSE -- для Киев - расход с него
                                        */

                                        /*WHEN ObjectLink_UnitFrom_Branch.ChildObjectId = vbBranchId
                                             THEN NULL -- FALSE -- для филиала - расход с него !!!блокируется!!!
                                        WHEN ObjectLink_UnitTo_Branch.ChildObjectId = vbBranchId
                                             THEN TRUE -- для филиала - приход на него
                                        WHEN ObjectLink_UnitTo_Branch.ChildObjectId > 0
                                             THEN NULL -- FALSE -- для главного - расход с него !!!блокируется!!!
                                        WHEN ObjectLink_UnitFrom_Branch.ChildObjectId > 0
                                             THEN TRUE -- для главного - приход на него
                                        */

                                   END AS isSendOnPriceIn

                            FROM _tmpMovement_find_all AS tmpMovement

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                              ON MovementLinkObject_Contract.MovementId = tmpMovement.Id
                                                             AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                              ON MovementLinkObject_Partner.MovementId = tmpMovement.Id
                                                             AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                              ON MovementLinkObject_From.MovementId = tmpMovement.Id
                                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = tmpMovement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = tmpMovement.Id
                                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                                 LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                      ON ObjectLink_Partner_Juridical.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_From.ObjectId)
                                                     AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                 LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Branch
                                                      ON ObjectLink_UnitFrom_Branch.ObjectId = MovementLinkObject_From.ObjectId
                                                     AND ObjectLink_UnitFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                 LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Branch
                                                      ON ObjectLink_UnitTo_Branch.ObjectId = MovementLinkObject_To.ObjectId
                                                     AND ObjectLink_UnitTo_Branch.DescId = zc_ObjectLink_Unit_Branch()

                                 LEFT JOIN tmpUnit_Branch AS tmpUnit_Branch_From ON tmpUnit_Branch_From.UnitId = MovementLinkObject_From.ObjectId
                                 LEFT JOIN tmpUnit_Branch AS tmpUnit_Branch_To   ON tmpUnit_Branch_To.UnitId   = CASE WHEN ObjectLink_UnitTo_Branch.ChildObjectId = 8377 -- филиал Кр.Рог
                                                                                                                       AND vbBranchId                             = zc_Branch_Basis()
                                                                                                                           THEN 8461 -- Склад Возвратов
                                                                                                                      ELSE MovementLinkObject_To.ObjectId
                                                                                                                 END

                                 LEFT JOIN Object AS Object_From ON Object_From.Id = CASE -- Для заявки поставщику
                                                                                          WHEN tmpMovement.DescId = zc_Movement_OrderIncome()

                                                                                               THEN MovementLinkObject_Unit.ObjectId

                                                                                          -- Для Мясного сырья - замена
                                                                                          WHEN tmpMovement.DescId = zc_Movement_OrderInternal()
                                                                                           AND inBranchCode BETWEEN 201 AND 210
                                                                                               THEN inFromId

                                                                                          -- Для остальных - Заявка покупателя или SendOnPrice или ReturnIn
                                                                                          ELSE MovementLinkObject_From.ObjectId

                                                                                     END
                                 LEFT JOIN Object AS Object_To   ON Object_To.Id   = CASE -- Для заявки поставщику
                                                                                          WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                                                                                               THEN (SELECT OL.ObjectId
                                                                                                     FROM MovementLinkObject AS MLO
                                                                                                          INNER JOIN ObjectLink AS OL ON OL.ChildObjectId = MLO.ObjectId AND OL.DescId = zc_ObjectLink_Partner_Juridical()
                                                                                                          INNER JOIN Object ON Object.Id = OL.ObjectId AND Object.isErased = FALSE
                                                                                                     WHERE MLO.MovementId = tmpMovement.Id
                                                                                                       AND MLO.DescId     = zc_MovementLinkObject_Juridical()
                                                                                                     LIMIT 1)

                                                                                          -- Для Мясного сырья - замена
                                                                                          WHEN tmpMovement.DescId = zc_Movement_OrderInternal()
                                                                                           AND inBranchCode BETWEEN 201 AND 210
                                                                                               THEN MovementLinkObject_From.ObjectId

                                                                                          -- Для Склад специй + Склад запчастей
                                                                                          WHEN MovementLinkObject_From.ObjectId = MovementLinkObject_To.ObjectId
                                                                                           AND inBranchCode BETWEEN 301 AND 310
                                                                                           AND tmpMovement.DescId = zc_Movement_OrderInternal()
                                                                                               THEN 8455 -- Склад специй

                                                                                          WHEN ObjectLink_UnitTo_Branch.ChildObjectId = 8377 -- филиал Кр.Рог
                                                                                           AND vbBranchId                             = zc_Branch_Basis()
                                                                                               THEN 8461 -- Склад Возвратов

                                                                                          -- Для остальных - Заявка покупателя или SendOnPrice или ReturnIn
                                                                                          ELSE MovementLinkObject_To.ObjectId

                                                                                     END
                           )
       , tmpMovement_find_all AS (SELECT tmpMovement.Id
                                       , MovementLinkMovement_Order.MovementId AS MovementId_get
                                       , MovementLinkObject_User.ObjectId      AS UserId
                                  FROM tmpMovement
                                       INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                       ON MovementLinkMovement_Order.MovementChildId = tmpMovement.Id
                                                                      AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                                       INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Order.MovementId
                                                          AND Movement.DescId = zc_Movement_WeighingPartner()
                                                          AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                       LEFT JOIN MovementLinkObject
                                              AS MovementLinkObject_User
                                              ON MovementLinkObject_User.MovementId = Movement.Id
                                             AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                                          -- AND MovementLinkObject_User.ObjectId = vbUserId
                                              -- AND vbUserId <> 5
                                 )
           , tmpMovement_find AS (SELECT tmpMovement_find_all.Id
                                       , tmpMovement_find_all.MovementId_get
                                  FROM tmpMovement_find_all
                                  WHERE tmpMovement_find_all.UserId = vbUserId
                                              -- AND vbUserId <> 5
                                 )
           , tmpJuridicalPrint AS (SELECT tmpGet.Id AS JuridicalId
                                        , tmpGet.isMovement, tmpGet.CountMovement
                                        , tmpGet.isAccount, tmpGet.CountAccount
                                        , tmpGet.isTransport, tmpGet.CountTransport
                                        , tmpGet.isQuality, tmpGet.CountQuality
                                        , tmpGet.isPack, tmpGet.CountPack
                                        , tmpGet.isSpec, tmpGet.CountSpec
                                        , tmpGet.isTax, tmpGet.CountTax
                                   FROM (SELECT tmpMovement.JuridicalId FROM tmpMovement WHERE tmpMovement.DescId = zc_Movement_OrderExternal() LIMIT 1) AS tmp
                                        INNER JOIN lpGet_Object_Juridical_PrintKindItem ((SELECT tmpMovement.JuridicalId FROM tmpMovement LIMIT 1)) AS tmpGet ON tmpGet.Id = tmp.JuridicalId
                                  )
      , tmpMovementDescNumber AS (SELECT tmpSelect.Number AS MovementDescNumber
                                       , tmp.MovementId
                                  FROM (SELECT -- !!!замена!!!
                                               CASE WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                                                         THEN zc_Movement_Income()
                                                    WHEN tmpMovement.DescId = zc_Movement_OrderInternal()
                                                         THEN zc_Movement_Send()
                                                    WHEN tmpMovement.DescId_From = zc_Object_ArticleLoss()
                                                         THEN zc_Movement_Loss()
                                                    /*WHEN tmpMovement.DescId = zc_Movement_OrderExternal()
                                                     AND tmpMovement.FromId = 3080691 -- Склад ГП ф.Львов
                                                     AND tmpMovement.ToId   = 8411    -- Склад ГП ф.Киев
                                                         THEN zc_Movement_Send()*/
                                                    WHEN tmpMovement.DescId_From = zc_Object_Unit()
                                                         THEN zc_Movement_SendOnPrice()

                                                    ELSE tmpMovement.DescId

                                               END AS MovementDescId

                                             , tmpMovement.DescId AS MovementDescId_original
                                             , tmpMovement.FromId
                                             , tmpMovement.ToId
                                             , tmpMovement.isSendOnPriceIn
                                             , tmpMovement.Id AS MovementId
                                        FROM tmpMovement
                                             -- LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovement.FromId
                                        WHERE tmpMovement.DescId = zc_Movement_OrderIncome()
                                           OR tmpMovement.DescId = zc_Movement_SendOnPrice()
                                           OR tmpMovement.DescId = zc_Movement_ReturnIn()
                                        -- OR Object_From.DescId = zc_Object_ArticleLoss()
                                        -- OR Object_From.DescId = zc_Object_Unit()
                                           OR tmpMovement.DescId_From = zc_Object_ArticleLoss()
                                           OR tmpMovement.DescId_From = zc_Object_Unit()
                                       ) AS tmp
                                       INNER JOIN gpSelect_Object_ToolsWeighing_MovementDesc (inIsCeh     := inIsCeh
                                                                                            , inBranchCode:= inBranchCode
                                                                                            , inSession   := inSession
                                                                                             )
                                                   AS tmpSelect ON tmpSelect.MovementDescId = tmp.MovementDescId
                                                               AND tmpSelect.FromId = CASE -- для Прихода от поставщика
                                                                                           WHEN tmp.MovementDescId = zc_Movement_Income()
                                                                                                THEN 0
                                                                                           -- для Перемещения
                                                                                           WHEN tmp.MovementDescId = zc_Movement_Send()
                                                                                                THEN tmp.ToId
                                                                                           -- для списания
                                                                                           WHEN tmp.MovementDescId = zc_Movement_Loss()
                                                                                                THEN tmp.ToId
                                                                                           -- для возврата от Покупателя
                                                                                           WHEN tmp.MovementDescId = zc_Movement_ReturnIn()
                                                                                                THEN 0
--    WHEN tmp.MovementDescId = zc_Movement_SendOnPrice()
--     AND tmp.FromId = 3080691 -- Склад ГП ф.Львов
--     AND tmp.ToId   = 8411    -- Склад ГП ф.Киев
--         THEN tmp.ToId
                                                                                           -- для ЛЮБОГО SendOnPrice по заявке
                                                                                           WHEN tmp.MovementDescId = zc_Movement_SendOnPrice() AND tmp.MovementDescId_original = zc_Movement_OrderExternal()
                                                                                                THEN tmp.ToId
                                                                                           -- для главного - расход с него
                                                                                           WHEN vbBranchId = zc_Branch_Basis() AND tmp.isSendOnPriceIn = FALSE
                                                                                                THEN tmp.FromId
                                                                                           -- для главного - приход на него, а здесь 0 т.к. он выбирается из справочника
                                                                                           WHEN vbBranchId = zc_Branch_Basis() AND tmp.isSendOnPriceIn = TRUE
                                                                                                THEN 0
                                                                                           -- для филиала - приход на него, а здесь FromId т.к. не выбирается
                                                                                           WHEN tmp.isSendOnPriceIn = TRUE
                                                                                                THEN tmp.FromId
                                                                                           -- для для филиала - расход с него
                                                                                           WHEN tmp.isSendOnPriceIn = FALSE
                                                                                                THEN tmp.FromId
                                                                                      END
                                                               AND tmpSelect.ToId   = CASE -- для Прихода от поставщика
                                                                                           WHEN tmp.MovementDescId = zc_Movement_Income()
                                                                                                THEN tmp.FromId
                                                                                           -- для Перемещения
                                                                                           WHEN tmp.MovementDescId = zc_Movement_Send()
                                                                                                THEN tmp.FromId
                                                                                           -- для списания здесь 0 т.к. он выбирается из справочника
                                                                                           WHEN tmp.MovementDescId = zc_Movement_Loss()
                                                                                                THEN 0
                                                                                           -- для возврата от Покупателя
                                                                                           WHEN tmp.MovementDescId = zc_Movement_ReturnIn()
                                                                                                THEN tmp.ToId
--    WHEN tmp.MovementDescId = zc_Movement_SendOnPrice()
--     AND tmp.FromId = 3080691 -- Склад ГП ф.Львов
--     AND tmp.ToId   = 8411    -- Склад ГП ф.Киев
--         THEN tmp.FromId
                                                                                           -- для главного SendOnPrice по заявке
                                                                                           WHEN vbBranchId = zc_Branch_Basis() AND tmp.MovementDescId = zc_Movement_SendOnPrice() AND tmp.MovementDescId_original = zc_Movement_OrderExternal()
                                                                                                THEN 0
                                                                                           -- для филиала SendOnPrice по заявке
                                                                                           WHEN tmp.MovementDescId = zc_Movement_SendOnPrice() AND tmp.MovementDescId_original = zc_Movement_OrderExternal()
                                                                                                THEN tmp.FromId
                                                                                           -- для главного - расход с него, а здесь 0 т.к. он выбирается из справочника
                                                                                           WHEN vbBranchId = zc_Branch_Basis() AND tmp.isSendOnPriceIn = FALSE
                                                                                                THEN 0
                                                                                           -- для главного - приход на него
                                                                                           WHEN vbBranchId = zc_Branch_Basis() AND tmp.isSendOnPriceIn = TRUE
                                                                                                THEN tmp.ToId
                                                                                           -- для филиала - приход на него
                                                                                           WHEN tmp.isSendOnPriceIn = TRUE
                                                                                                THEN tmp.ToId
                                                                                           -- для для филиала - расход с него, а здесь ToId т.к. не выбирается
                                                                                           WHEN tmp.isSendOnPriceIn = FALSE
                                                                                                THEN tmp.ToId
                                                                                      END
                                                               AND COALESCE (tmpSelect.PaidKindId, 0) = CASE WHEN tmp.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnIn())
                                                                                                                  THEN (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = tmp.MovementId AND MLO.DescId = zc_MovementLinkObject_PaidKind())
                                                                                                             ELSE COALESCE (tmpSelect.PaidKindId, 0)
                                                                                                        END
                                                               AND COALESCE (tmpSelect.GoodsId_ReWork, 0) = 0 
                                 )
           , tmpMLO_PriceList AS (SELECT *
                                  FROM MovementLinkObject AS MLO_PriceList
                                  WHERE MLO_PriceList.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
                                    AND MLO_PriceList.DescId     = zc_MovementLinkObject_PriceList()
                                 )
           , tmpMLM AS (SELECT *
                        FROM MovementLinkMovement AS MLM
                        WHERE MLM.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                       )
           , tmpMS AS (SELECT *
                        FROM MovementString AS MS
                        WHERE MS.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                       )
           , tmpMF AS (SELECT *
                        FROM MovementFloat AS MF
                        WHERE MF.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                          AND MF.DescId = zc_MovementFloat_ChangePercent()
                       )
           , tmpMLO AS (SELECT *
                        FROM MovementLinkObject
                        WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                          AND MovementLinkObject.DescId = zc_MovementLinkObject_Personal()
                       )
    , tmpMovement_ContractGoods AS (SELECT MLO_Contract.ObjectId AS ContractId
                                    FROM Movement
                                         INNER JOIN MovementLinkObject AS MLO_Contract
                                                                       ON MLO_Contract.MovementId = Movement.Id
                                                                      AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                                    WHERE Movement.DescId    = zc_Movement_ContractGoods()
                                      AND Movement.StatusId  = zc_Enum_Status_Complete()
                                   )

       -- Результат
       SELECT tmpMovement.Id                                 AS MovementId
            , tmpMovement.DescId                             AS MovementDescId_order
            , tmpMovement_find.MovementId_get                AS MovementId_get
            , inBarCode                                      AS BarCode
            , tmpMovement.InvNumber                          AS InvNumber
            , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner

            , tmpMovementDescNumber.MovementDescNumber       AS MovementDescNumber -- !!!только для zc_Movement_SendOnPrice!!!
            , CASE WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                        THEN zc_Movement_Income()
                   WHEN tmpMovement.DescId = zc_Movement_OrderInternal()
                        THEN zc_Movement_Send()
                   WHEN tmpMovement.DescId_From = zc_Object_ArticleLoss()
                        THEN zc_Movement_Loss()

                   /*WHEN (tmpMovement.DescId = zc_Movement_OrderExternal()
                    AND tmpMovement.FromId = 3080691 -- Склад ГП ф.Львов
                    AND tmpMovement.ToId   = 8411    -- Склад ГП ф.Киев
                    ) -- or vbUserId = 5
                        THEN zc_Movement_Send()*/

                   WHEN tmpMovement.DescId_From = zc_Object_Unit()
                        THEN zc_Movement_SendOnPrice()

                   WHEN tmpMovement.DescId = zc_Movement_OrderExternal()
                        THEN zc_Movement_Sale()

                   ELSE tmpMovement.DescId

              END AS MovementDescId
            , tmpMovement.FromId                             AS FromId
            , tmpMovement.FromCode                           AS FromCode
            , tmpMovement.FromName                           AS FromName
            , tmpMovement.ToId                               AS ToId
            , tmpMovement.ToCode                             AS ToCode
            , tmpMovement.ToName                             AS ToName
            , Object_PaidKind.Id                             AS PaidKindId
            , Object_PaidKind.ValueData                      AS PaidKindName

            , Object_PriceList.Id                            AS PriceListId
            , Object_PriceList.ObjectCode                    AS PriceListCode
            , Object_PriceList.ValueData                     AS PriceListName
            , View_Contract_InvNumber.ContractId             AS ContractId
            , View_Contract_InvNumber.ContractCode           AS ContractCode
            , View_Contract_InvNumber.InvNumber              AS ContractNumber
            , View_Contract_InvNumber.ContractTagName        AS ContractTagName

            , Object_GoodsProperty.Id                        AS GoodsPropertyId
            , Object_GoodsProperty.ObjectCode                AS GoodsPropertyCode
            , Object_GoodsProperty.ValueData                 AS GoodsPropertyName

            , CASE WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                        THEN tmpMovement.ToId
                   WHEN tmpMovement.DescId = zc_Movement_OrderExternal()
                        THEN tmpMovement.FromId
                   WHEN tmpMovement.DescId = zc_Movement_ReturnIn()
                        THEN tmpMovement.FromId
                   WHEN tmpMovement.DescId = zc_Movement_SendOnPrice() AND tmpMovement.isSendOnPriceIn = TRUE
                        THEN tmpMovement.FromId
                   WHEN tmpMovement.DescId = zc_Movement_SendOnPrice() AND tmpMovement.isSendOnPriceIn = FALSE
                        THEN tmpMovement.ToId
              END :: Integer AS PartnerId_calc
            , CASE WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                        THEN tmpMovement.ToCode
                   WHEN tmpMovement.DescId = zc_Movement_OrderExternal()
                        THEN tmpMovement.FromCode
                   WHEN tmpMovement.DescId = zc_Movement_ReturnIn()
                        THEN tmpMovement.FromCode
                   WHEN tmpMovement.DescId = zc_Movement_SendOnPrice() AND tmpMovement.isSendOnPriceIn = TRUE
                        THEN tmpMovement.FromCode
                   WHEN tmpMovement.DescId = zc_Movement_SendOnPrice() AND tmpMovement.isSendOnPriceIn = FALSE
                        THEN tmpMovement.ToCode
              END :: Integer AS PartnerCode_calc
            , CASE WHEN tmpMovement.DescId = zc_Movement_OrderIncome()
                        THEN tmpMovement.ToName
                   WHEN tmpMovement.DescId = zc_Movement_OrderExternal()
                        THEN tmpMovement.FromName
                   WHEN tmpMovement.DescId = zc_Movement_ReturnIn()
                        THEN tmpMovement.FromName
                   WHEN tmpMovement.DescId = zc_Movement_SendOnPrice() AND tmpMovement.isSendOnPriceIn = TRUE
                        THEN tmpMovement.FromName
                   WHEN tmpMovement.DescId = zc_Movement_SendOnPrice() AND tmpMovement.isSendOnPriceIn = FALSE
                        THEN tmpMovement.ToName
              END :: TVarChar AS PartnerName_calc

            , MovementFloat_ChangePercent.ValueData AS ChangePercent
            , (SELECT tmp.ChangePercentAmount FROM gpGet_Scale_Partner (inOperDate       := inOperDate
                                                                      , inMovementDescId := CASE WHEN tmpMovement.DescId_From = zc_Object_ArticleLoss()
                                                                                                      THEN zc_Movement_Loss()
                                                                                                 WHEN tmpMovement.DescId_From = zc_Object_Unit() AND tmpMovement.DescId = zc_Movement_OrderExternal()
                                                                                                      THEN zc_Movement_SendOnPrice()
                                                                                                 WHEN tmpMovement.DescId = zc_Movement_OrderExternal()
                                                                                                      THEN zc_Movement_Sale()
                                                                                                 ELSE tmpMovement.DescId
                                                                                            END
                                                                      , inPartnerCode    := -1 * tmpMovement.FromId
                                                                      , inInfoMoneyId    := COALESCE (View_Contract_InvNumber.InfoMoneyId, zc_Enum_InfoMoney_30101())
                                                                      , inPaidKindId     := Object_PaidKind.Id
                                                                      , inSession        := inSession
                                                                       ) AS tmp
               WHERE COALESCE (tmp.ContractId, 0) = COALESCE (View_Contract_InvNumber.ContractId, 0)
                  OR tmpMovement.DescId_From = zc_Object_Unit()
              ) AS ChangePercentAmount

            , COALESCE (ObjectBoolean_Partner_EdiOrdspr.ValueData, FALSE)  :: Boolean AS isEdiOrdspr
            , COALESCE (ObjectBoolean_Partner_EdiInvoice.ValueData, FALSE) :: Boolean AS isEdiInvoice
            , COALESCE (ObjectBoolean_Partner_EdiDesadv.ValueData, FALSE)  :: Boolean AS isEdiDesadv

            , CASE WHEN tmpJuridicalPrint.isPack = TRUE OR tmpJuridicalPrint.isSpec = TRUE THEN COALESCE (tmpJuridicalPrint.isMovement, FALSE) ELSE TRUE END :: Boolean AS isMovement
            , CASE WHEN tmpJuridicalPrint.CountMovement > 0 THEN tmpJuridicalPrint.CountMovement ELSE 2 END :: TFloat AS CountMovement
            , COALESCE (tmpJuridicalPrint.isAccount,   FALSE) :: Boolean AS isAccount,   COALESCE (tmpJuridicalPrint.CountAccount, 0)   :: TFloat AS CountAccount
            , CASE WHEN Object_PaidKind.Id = zc_Enum_PaidKind_FirstForm() THEN TRUE ELSE COALESCE (tmpJuridicalPrint.isTransport, FALSE) END  :: Boolean AS isTransport
            , CASE WHEN Object_PaidKind.Id = zc_Enum_PaidKind_FirstForm() THEN 1    ELSE COALESCE (tmpJuridicalPrint.CountTransport, 0)  END  :: TFloat  AS CountTransport
            , COALESCE (tmpJuridicalPrint.isQuality,   FALSE) :: Boolean AS isQuality  , COALESCE (tmpJuridicalPrint.CountQuality, 0)   :: TFloat AS CountQuality
            , COALESCE (tmpJuridicalPrint.isPack,      FALSE) :: Boolean AS isPack     , COALESCE (tmpJuridicalPrint.CountPack, 0)      :: TFloat AS CountPack
            , COALESCE (tmpJuridicalPrint.isSpec,      FALSE) :: Boolean AS isSpec     , COALESCE (tmpJuridicalPrint.CountSpec, 0)      :: TFloat AS CountSpec
            , COALESCE (tmpJuridicalPrint.isTax,       FALSE) :: Boolean AS isTax      , COALESCE (tmpJuridicalPrint.CountTax, 0)       :: TFloat AS CountTax

            , EXISTS (SELECT 1
                      FROM tmpMovement_ContractGoods
                      WHERE tmpMovement_ContractGoods.ContractId   = View_Contract_InvNumber.ContractId
                     ) :: Boolean AS isContractGoods

            , ('№ <' || tmpMovement.InvNumber || '>' || ' от <' || DATE (tmpMovement.OperDate) :: TVarChar || '>' || ' '|| COALESCE (Object_Personal.ValueData, '')) :: TVarChar AS OrderExternalName_master

       FROM tmpMovement
            LEFT JOIN tmpMovement_find ON tmpMovement_find.Id = tmpMovement.Id
            LEFT JOIN tmpMovementDescNumber ON tmpMovementDescNumber.MovementDescNumber > 0
            LEFT JOIN tmpJuridicalPrint ON tmpJuridicalPrint.JuridicalId = tmpMovement.JuridicalId

            -- LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovement.FromId
            -- LEFT JOIN Object AS Object_To   ON Object_To.Id   = tmpMovement.ToId

            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpMovement.ContractId
            LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = tmpMovement.GoodsPropertyId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = tmpMovement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                        AND tmpMovement.DescId IN (zc_Movement_OrderExternal(), zc_Movement_OrderIncome())
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = tmpMovement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                        AND tmpMovement.DescId = zc_Movement_OrderIncome()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                 ON ObjectLink_Juridical_PriceList.ObjectId = MovementLinkObject_Juridical.ObjectId
                                AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()

            -- LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
            LEFT JOIN tmpMLO_PriceList AS MovementLinkObject_PriceList
                                         ON MovementLinkObject_PriceList.MovementId = tmpMovement.Id
                                        AND MovementLinkObject_PriceList.DescId     = zc_MovementLinkObject_PriceList()
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = COALESCE (ObjectLink_Juridical_PriceList.ChildObjectId, CASE WHEN tmpMovement.DescId = zc_Movement_OrderIncome() THEN zc_PriceList_Basis() ELSE MovementLinkObject_PriceList.ObjectId END)

            LEFT JOIN tmpMF AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  tmpMovement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
            LEFT JOIN tmpMS AS MovementString_InvNumberPartner
                            ON MovementString_InvNumberPartner.MovementId =  tmpMovement.Id
                           AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN tmpMLM AS MovementLinkMovement_Order
                             ON MovementLinkMovement_Order.MovementId = tmpMovement.Id
                            AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiOrdspr
                                    ON ObjectBoolean_Partner_EdiOrdspr.ObjectId =  tmpMovement.FromId
                                   AND ObjectBoolean_Partner_EdiOrdspr.DescId = zc_ObjectBoolean_Partner_EdiOrdspr()
                                   AND MovementLinkMovement_Order.MovementChildId > 0 -- проверка по связи заявки с EDI
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiInvoice
                                    ON ObjectBoolean_Partner_EdiInvoice.ObjectId =  tmpMovement.FromId
                                   AND ObjectBoolean_Partner_EdiInvoice.DescId = zc_ObjectBoolean_Partner_EdiInvoice()
                                   AND MovementLinkMovement_Order.MovementChildId > 0 -- проверка по связи заявки с EDI
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiDesadv
                                    ON ObjectBoolean_Partner_EdiDesadv.ObjectId =  tmpMovement.FromId
                                   AND ObjectBoolean_Partner_EdiDesadv.DescId = zc_ObjectBoolean_Partner_EdiDesadv()
                                   AND MovementLinkMovement_Order.MovementChildId > 0 -- проверка по связи заявки с EDI

            LEFT JOIN tmpMLO AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = tmpMovement.Id
                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId
      ;
/*
     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
     INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                                    AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE position( 'autovacuum: VACUUM' in query) = 1) AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц ДО lpSelectMinPrice_List
             , NULL AS Time2
               -- сколько всего выполнялась проц lpSelectMinPrice_List
             , NULL AS Time3
               -- сколько всего выполнялась проц ПОСЛЕ lpSelectMinPrice_List
             , NULL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpGet_Scale_OrderExternal'
               -- ProtocolData
             , zfConvert_DateToString (inOperDate)
    || ', ' || inBranchCode :: TVarChar
    || ', ' || inBarCode
    || ', ' || inSession
              ;*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.01.15                                        *
*/

-- тест
-- SELECT * FROM gpGet_Scale_OrderExternal (inIsCeh:= TRUE, inOperDate:= CURRENT_DATE, inFromId:= 1, inToId:= 1, inBranchCode:= 301, inBarCode:= '135', inSession := '5');
