-- Function: lpComplete_Movement_OrderExternal()

DROP FUNCTION IF EXISTS lpComplete_Movement_OrderExternal (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_OrderExternal(
    IN inMovementId        Integer              , -- ключ Документа
   OUT outPrinted          Boolean              ,
   OUT outMessageText      Text                 ,
    IN inUserId            Integer     -- пользователь
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbOperSumm_Partner_byItem TFloat;
  DECLARE vbOperSumm_Partner TFloat;

  DECLARE vbOperDate            TDateTime;
  DECLARE vbOperDatePartner     TDateTime;
  DECLARE vbPriceWithVAT        Boolean;
  DECLARE vbVATPercent          TFloat;
  DECLARE vbDiscountPercent     TFloat;
  DECLARE vbExtraChargesPercent TFloat;

  DECLARE vbPartnerId           Integer;
  DECLARE vbJuridicalId         Integer;
  DECLARE vbUnitId_From         Integer;
  DECLARE vbArticleLoss_From    Integer;
  DECLARE vbContractId          Integer;
  DECLARE vbRouteId             Integer;
  DECLARE vbRetailId            Integer;
  DECLARE vbUnitId_to           Integer;

  DECLARE vbCriticalWeight      TFloat;
  DECLARE vbSummOrderMin        TFloat;
  DECLARE vbIsLessWeigth        Boolean;
  DECLARE vbMovementId_CarInfo  Integer;
  DECLARE vbIsSamoV             Boolean;
BEGIN
     outPrinted := gpUpdate_Movement_OrderExternal_Print(inId := inMovementId , inNewPrinted := FALSE,  inSession := lfGet_User_Session (inUserId));

     --
     vbCriticalWeight:= (SELECT tmpGet.CriticalWeight FROM gpGetMobile_Object_Const (inSession:= zfCalc_UserAdmin()) AS tmpGet);

     -- таблица - элементы документа
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , GoodsId Integer, GoodsKindId Integer
                               , OperCount TFloat, OperCount_Second TFloat, OperCount_Weight TFloat, OperCount_Weight_Second TFloat, OperSumm_Partner TFloat
                               , ChangePercent TFloat, PriceEDI TFloat, Price TFloat, Price_original TFloat, CountForPrice TFloat) ON COMMIT DROP;


     -- Эти параметры нужны для расчета конечных сумм по Контрагенту или Сотуднику и для формирования Аналитик в проводках
     SELECT Movement.OperDate
          , MovementDate_OperDatePartner.ValueData AS OperDatePartner
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0) AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner() THEN Object_From.Id ELSE 0 END, 0) AS PartnerId
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() OR (MovementLinkObject_Route.ObjectId IS NULL AND Object_Route.Id IS NULL) THEN Object_From.Id ELSE 0 END, 0) AS UnitId_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_ArticleLoss() THEN Object_From.Id ELSE 0 END, 0) AS ArticleLoss_From

          , MovementLinkObject_Route.ObjectId AS RouteId

          , CASE WHEN Object_From.DescId = zc_Object_Unit()
                      THEN 0
                 -- временно
                 WHEN Object_Route.ValueData ILIKE 'Маршрут №%'
                   OR Object_Route.ValueData ILIKE 'Самов%'
                   OR Object_Route.ValueData ILIKE '%-колбаса'
                   OR Object_Route.ValueData ILIKE '%Кривой Рог%'
                      THEN 0
                 ELSE COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, 0)
            END AS RetailId
            
          , CASE -- временно
                 WHEN Object_Route.ValueData ILIKE 'Самов%'
                   OR MovementString_Comment.ValueData ILIKE 'Самов%'
                      THEN TRUE
                 ELSE FALSE
            END AS IsSamoV

          , MovementLinkObject_To.ObjectId AS UnitId_to

          , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
          , COALESCE (OL_Juridical.ChildObjectId, 0)           AS JuridicalId

          , CASE WHEN COALESCE (Object_Route.ValueData, '')    ILIKE '%самовывоз%'
                   OR COALESCE (Object_Contract.ValueData, '') ILIKE '%обмен%'
                   OR COALESCE (Object_Contract.ValueData, '') ILIKE '%обмін%'
                   OR COALESCE (Object_Contract.ValueData, '') ILIKE '%обмiн%'
                   OR COALESCE (ObjectBoolean_isOrderMin.ValueData, FALSE) = TRUE
                   --OR COALESCE (vbCriticalWeight, 0) = 0
                   --OR COALESCE (ObjectFloat_SummOrderMin.ValueData, 0) = 0
                   --
                   OR MovementString_Comment.ValueData ILIKE 'Самов%'

                      THEN TRUE
                 ELSE FALSE
            END AS isLessWeigth


          , ObjectFloat_SummOrderMin.ValueData AS SummOrderMin

            INTO vbOperDate, vbOperDatePartner
               , vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent
               , vbPartnerId, vbUnitId_From, vbArticleLoss_From, vbRouteId, vbRetailId, vbIsSamoV, vbUnitId_to
               , vbContractId, vbJuridicalId, vbIsLessWeigth, vbSummOrderMin
     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
          LEFT JOIN MovementString AS MovementString_Comment
                                   ON MovementString_Comment.MovementId = Movement.Id
                                  AND MovementString_Comment.DescId = zc_MovementString_Comment()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

          LEFT JOIN ObjectLink AS OL_Juridical
                               ON OL_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                              AND OL_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
          -- Разрешен минимальный заказ - меньше 5 кг.
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isOrderMin
                                  ON ObjectBoolean_isOrderMin.ObjectId = OL_Juridical.ChildObjectId
                                 AND ObjectBoolean_isOrderMin.DescId   = zc_ObjectBoolean_Juridical_isOrderMin()
          -- Разрешен Минимальный заказ с суммой >=
          LEFT JOIN ObjectFloat AS ObjectFloat_SummOrderMin
                                ON ObjectFloat_SummOrderMin.ObjectId = OL_Juridical.ChildObjectId
                               AND ObjectFloat_SummOrderMin.DescId   = zc_ObjectFloat_Juridical_SummOrderMin()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                       ON MovementLinkObject_Route.MovementId = Movement.Id
                                      AND MovementLinkObject_Route.DescId     = zc_MovementLinkObject_Route()
          LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_OrderExternal()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


     -- проверка
     IF COALESCE (vbContractId, 0) = 0 AND vbUnitId_From = 0 AND vbArticleLoss_From = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определен <Договор>.Проведение невозможно.';
     END IF;


     -- проверка
     IF COALESCE (vbJuridicalId, 0) <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbContractId AND OL.DescId = zc_ObjectLink_Contract_Juridical()), 0)
        AND inUserId <> 5
     THEN
         RAISE EXCEPTION 'Ошибка.В документе выбран договор%для Юридического лица = <%>.%Необходимо выбрать договор%для Юридического лица = <%>.'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbContractId AND OL.DescId = zc_ObjectLink_Contract_Juridical()))
                       , CHR (13)
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (vbJuridicalId)
                        ;
/*
select Object_Juridical_contract .ValueData, Object_Juridical_partner.ValueData, Movement.*, Object_From.*
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_ContractFrom
                                       ON MovementLinkObject_ContractFrom.MovementId = Movement.Id
                                      AND MovementLinkObject_ContractFrom.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN ObjectLink AS ObjectLink_ContractFrom_Juridical
                               ON ObjectLink_ContractFrom_Juridical.ObjectId = MovementLinkObject_ContractFrom.ObjectId
                              AND ObjectLink_ContractFrom_Juridical.DescId    = zc_ObjectLink_Contract_Juridical()

          LEFT JOIN Object AS Object_Juridical_contract ON Object_Juridical_contract.Id = ObjectLink_ContractFrom_Juridical.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_PartnerFrom_Juridical
                               ON ObjectLink_PartnerFrom_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_PartnerFrom_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN Object AS Object_Juridical_partner ON Object_Juridical_partner.Id = ObjectLink_PartnerFrom_Juridical.ChildObjectId

     WHERE Movement.DescId IN (zc_Movement_OrderExternal())
       AND Movement.StatusId = zc_Enum_Status_Complete() -- IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());
       -- AND Movement.OperDate between '01.05.2020' and '01.12.2020'
       AND Movement.OperDate between '01.01.2021' and '01.12.2021'
--       AND Movement.Id = 17522252
 and ObjectLink_PartnerFrom_Juridical.ChildObjectId <> ObjectLink_ContractFrom_Juridical.ChildObjectId
order by Movement.OperDate*/
     END IF;


     -- заполняем
     IF EXISTS (SELECT 1
                FROM MovementDate
                WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_CarInfo()
                  AND (DATE_TRUNC ('DAY', MovementDate.ValueData) = MovementDate.ValueData
                    OR EXTRACT (HOUR FROM MovementDate.ValueData) = 0
                      )
               )
        AND vbUnitId_to = 8459 -- Розподільчий комплекс
        AND inUserId = 5
        AND 1=0
     THEN
         -- Нашли
         vbMovementId_CarInfo:= (SELECT MAX (Movement.Id)
                                 FROM Movement
                                      -- Склад такой же
                                      INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                    ON MovementLinkObject_To.MovementId = Movement.Id
                                                                   AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                                   AND MovementLinkObject_To.ObjectId   = vbUnitId_to
                                      -- Маршрут такой же
                                      INNER JOIN MovementLinkObject AS MovementLinkObject_Route
                                                                    ON MovementLinkObject_Route.MovementId = Movement.Id
                                                                   AND MovementLinkObject_Route.DescId     = zc_MovementLinkObject_Route()
                                                                   AND MovementLinkObject_Route.ObjectId   = vbRouteId
                                      -- установлена дата
                                      INNER JOIN MovementDate AS MovementDate_CarInfo
                                                              ON MovementDate_CarInfo.MovementId = Movement.Id
                                                             AND MovementDate_CarInfo.DescId     = zc_MovementDate_CarInfo()
                                                             AND (MovementDate_CarInfo.ValueData <> DATE_TRUNC ('DAY', MovementDate_CarInfo.ValueData)
                                                               OR EXTRACT (HOUR FROM MovementDate_CarInfo.ValueData) <> 0
                                                                 )
                                      -- Дата такая же
                                      INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                              ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                                             AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                                                             AND MovementDate_OperDatePartner.ValueData  = vbOperDatePartner
                                      INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                      LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                           ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

                                 WHERE Movement.OperDate = vbOperDate
                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                   AND Movement.DescId   = zc_Movement_OrderExternal()
                                   AND (ObjectLink_Juridical_Retail.ChildObjectId = vbRetailId    OR COALESCE (vbRetailId, 0)    = 0)
                                   AND (MovementLinkObject_From.ObjectId          = vbUnitId_From OR COALESCE (vbUnitId_From, 0) = 0)
                                );

         -- RAISE EXCEPTION 'Ошибка.%', vbMovementId_CarInfo;

         -- Если нашли
         IF vbMovementId_CarInfo > 0
         THEN
             -- заполняем
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_CarInfo(), inMovementId, tmp.OperDate_CarInfo)        -- Дата/время отгрузки
                   , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CarInfo(), inMovementId, tmp.CarInfoId)   -- Информация по отгрузке
                   , lpInsertUpdate_MovementString (zc_MovementString_CarComment(), inMovementId, tmp.CarComment)       -- примечание к отгрузке
             FROM (SELECT MovementDate_CarInfo.ValueData      AS OperDate_CarInfo
                        , MovementLinkObject_CarInfo.ObjectId AS CarInfoId
                        , MovementString_CarComment.ValueData AS CarComment
                   FROM MovementDate AS MovementDate_CarInfo

                        LEFT JOIN MovementLinkObject AS MovementLinkObject_CarInfo
                                                     ON MovementLinkObject_CarInfo.MovementId = MovementDate_CarInfo.MovementId
                                                    AND MovementLinkObject_CarInfo.DescId     = zc_MovementLinkObject_CarInfo()
                        LEFT JOIN MovementString AS MovementString_CarComment
                                                 ON MovementString_CarComment.MovementId = MovementDate_CarInfo.MovementId
                                                AND MovementString_CarComment.DescId     = zc_MovementString_CarComment()

                   WHERE MovementDate_CarInfo.MovementId = vbMovementId_CarInfo
                     AND MovementDate_CarInfo.DescId     = zc_MovementDate_CarInfo()
                  ) AS tmp;
         ELSE
             -- заполняем
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_CarInfo(), inMovementId, tmp.OperDate_CarInfo)        -- Дата/время отгрузки
             FROM (SELECT COALESCE (
                                    (SELECT -- !!!Дата/время отгрузки - Расчет!!!
                                           (vbOperDatePartner 
                                          + ((CASE WHEN ObjectFloat_Days.ValueData > 0 THEN  1 * ObjectFloat_Days.ValueData ELSE 0 END :: Integer) :: TVarChar || ' DAY') :: INTERVAL
                                          - ((CASE WHEN ObjectFloat_Days.ValueData < 0 THEN -1 * ObjectFloat_Days.ValueData ELSE 0 END :: Integer) :: TVarChar || ' DAY') :: INTERVAL
                                          + ((COALESCE (ObjectFloat_Hour.ValueData, 0) :: Integer) :: TVarChar || ' HOUR')   :: INTERVAL
                                          + ((COALESCE (ObjectFloat_Min.ValueData, 0)  :: Integer) :: TVarChar || ' MINUTE') :: INTERVAL
                                           ) :: TDateTime
                                    FROM Object AS Object_OrderCarInfo
                                         LEFT JOIN ObjectLink AS ObjectLink_Route
                                                              ON ObjectLink_Route.ObjectId = Object_OrderCarInfo.Id
                                                             AND ObjectLink_Route.DescId   = zc_ObjectLink_OrderCarInfo_Route()
                                         LEFT JOIN ObjectLink AS ObjectLink_Retail
                                                              ON ObjectLink_Retail.ObjectId = Object_OrderCarInfo.Id
                                                             AND ObjectLink_Retail.DescId   = zc_ObjectLink_OrderCarInfo_Retail()

                                         INNER JOIN ObjectLink AS ObjectLink_Unit
                                                               ON ObjectLink_Unit.ObjectId      = Object_OrderCarInfo.Id
                                                              AND ObjectLink_Unit.DescId        = zc_ObjectLink_OrderCarInfo_Unit()
                                                              AND ObjectLink_Unit.ChildObjectId = vbUnitId_to

                                         INNER JOIN ObjectFloat AS ObjectFloat_OperDate
                                                                ON ObjectFloat_OperDate.ObjectId  = Object_OrderCarInfo.Id
                                                               AND ObjectFloat_OperDate.DescId    = zc_ObjectFloat_OrderCarInfo_OperDate()
                                                               AND ObjectFloat_OperDate.ValueData =  zfCalc_DayOfWeekNumber (vbOperDate)
                                         INNER JOIN ObjectFloat AS ObjectFloat_OperDatePartner
                                                                ON ObjectFloat_OperDatePartner.ObjectId  = Object_OrderCarInfo.Id
                                                               AND ObjectFloat_OperDatePartner.DescId    = zc_ObjectFloat_OrderCarInfo_OperDatePartner()
                                                               AND ObjectFloat_OperDatePartner.ValueData = zfCalc_DayOfWeekNumber (vbOperDatePartner)

                                         LEFT JOIN ObjectFloat AS ObjectFloat_Days
                                                               ON ObjectFloat_Days.ObjectId = Object_OrderCarInfo.Id
                                                              AND ObjectFloat_Days.DescId = zc_ObjectFloat_OrderCarInfo_Days()
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Hour
                                                               ON ObjectFloat_Hour.ObjectId = Object_OrderCarInfo.Id
                                                              AND ObjectFloat_Hour.DescId = zc_ObjectFloat_OrderCarInfo_Hour()
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Min
                                                               ON ObjectFloat_Min.ObjectId = Object_OrderCarInfo.Id
                                                              AND ObjectFloat_Min.DescId = zc_ObjectFloat_OrderCarInfo_Min()
                                    WHERE Object_OrderCarInfo.DescId   = zc_Object_OrderCarInfo()
                                      AND Object_OrderCarInfo.isErased = FALSE
                                      AND COALESCE (ObjectLink_Route.ChildObjectId, 0)  = COALESCE (vbRouteId, 0)
                                      AND (ObjectLink_Retail.ChildObjectId = vbRetailId    OR COALESCE (vbRetailId, 0) = 0)
                                      AND (ObjectLink_Retail.ChildObjectId = vbUnitId_From OR COALESCE (vbUnitId_From, 0) = 0)
                                    ORDER BY ObjectFloat_Hour.ValueData DESC
                                    LIMIT 1
                                   )
                                 , MovementDate_CarInfo.ValueData
                                  ) AS OperDate_CarInfo
                   FROM MovementDate AS MovementDate_CarInfo
                   WHERE MovementDate_CarInfo.MovementId = inMovementId
                     AND MovementDate_CarInfo.DescId     = zc_MovementDate_CarInfo()
                  ) AS tmp;
         END IF;
     END IF;

     -- заполняем
     IF vbUnitId_to = 8459 -- Розподільчий комплекс
    --AND vbIsSamoV = TRUE
      AND vbOperDate = (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_CarInfo())
     THEN
         IF vbIsSamoV = TRUE
         THEN
             -- Дата/время отгрузки
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_CarInfo(), inMovementId, vbOperDate + INTERVAL '1 DAY' + INTERVAL '0 MIN');
         ELSE
             -- Дата/время отгрузки
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_CarInfo(), inMovementId, vbOperDate + INTERVAL '1 DAY' + INTERVAL '0 MIN');
          END IF;
     END IF;


     -- заполняем таблицу - количественные элементы документа, со всеми свойствами
     INSERT INTO _tmpItem (MovementItemId
                         , GoodsId, GoodsKindId
                         , OperCount, OperCount_Second, OperCount_Weight, OperCount_Weight_Second, OperSumm_Partner
                         , ChangePercent, PriceEDI, Price, Price_original, CountForPrice)
        SELECT
              _tmp.MovementItemId
            , _tmp.GoodsId
            , _tmp.GoodsKindId

            , _tmp.OperCount
            , _tmp.OperCount_Second
              -- вес
            , _tmp.OperCount_Weight
              -- вес дозаказ
            , _tmp.OperCount_Weight_Second

              -- конечная сумма по Контрагенту - с округлением до 2-х знаков
            , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но скидка/наценка учтена в цене!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                ELSE _tmp.tmpOperSumm_Partner
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но скидка/наценка учтена в цене!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но скидка/наценка учтена в цене!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp.tmpOperSumm_Partner) AS NUMERIC (16, 2))
                           END
              END AS OperSumm_Partner

            , _tmp.ChangePercent
            , _tmp.PriceEDI
            , _tmp.Price
            , _tmp.Price_original
            , _tmp.CountForPrice
        FROM
             (SELECT
                    tmpMI.MovementItemId
                  , tmpMI.GoodsId
                  , tmpMI.GoodsKindId

                  , tmpMI.ChangePercent
                  , tmpMI.PriceEDI
                  , tmpMI.Price
                  , tmpMI.Price_original
                  , tmpMI.CountForPrice
                    -- количество
                  , tmpMI.OperCount
                    -- количество дозаказ
                  , tmpMI.OperCount_Second
                    -- вес
                  , tmpMI.OperCount_Weight
                    -- вес дозаказ
                  , tmpMI.OperCount_Weight_Second

                    -- промежуточная сумма по Контрагенту - с округлением до 2-х знаков
                  , CASE WHEN tmpMI.CountForPrice <> 0 THEN CAST ((tmpMI.OperCount + tmpMI.OperCount_Second) * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST ((tmpMI.OperCount + tmpMI.OperCount_Second) * tmpMI.Price AS NUMERIC (16, 2))
                    END AS tmpOperSumm_Partner
              FROM
             (SELECT MovementItem.Id AS MovementItemId
                   , MovementItem.ObjectId AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId

                   , (MovementItem.Amount) AS OperCount
                   , (COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS OperCount_Second

                   , (MovementItem.Amount                          * CASE WHEN ObjectLink_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) AS OperCount_Weight
                   , (COALESCE (MIFloat_AmountSecond.ValueData, 0) * CASE WHEN ObjectLink_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) AS OperCount_Weight_Second

                   , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent
                   , COALESCE (MIFloat_PriceEDI.ValueData, 0) AS PriceEDI
                   , CASE WHEN COALESCE (MIFloat_ChangePercent.ValueData, 0) <> 0 -- vbDiscountPercent <> 0
                               -- скидка / наценка в цене - с округлением до 2-х знаков
                               THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                        , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                        , inPrice        := MIFloat_Price.ValueData
                                                        , inIsWithVAT    := vbPriceWithVAT
                                                         )
                          ELSE COALESCE (MIFloat_Price.ValueData, 0)
                     END AS Price
                   , COALESCE (MIFloat_Price.ValueData, 0) AS Price_original
                   , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                   LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                               ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                   LEFT JOIN MovementItemFloat AS MIFloat_PriceEDI
                                               ON MIFloat_PriceEDI.MovementItemId = MovementItem.Id
                                              AND MIFloat_PriceEDI.DescId = zc_MIFloat_PriceEDI()
                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                   LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                               ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                              AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                   LEFT JOIN ObjectLink AS ObjectLink_Measure
                                        ON ObjectLink_Measure.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                   LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                         ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                        AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_OrderExternal()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS tmpMI
             ) AS _tmp;

     -- проверка - если не разрешен вес < 5 и в документе < 5
     IF vbIsLessWeigth = FALSE AND COALESCE ((SELECT SUM (_tmpItem.OperCount_Weight) FROM _tmpItem), 0) < vbCriticalWeight
        AND COALESCE (vbSummOrderMin, 0) = 0
        AND 1=0
     THEN
       /*RAISE EXCEPTION 'Ошибка.Разрешены заявки с общим весом >= % кг.%Проведение заявки с весом = % кг. невозможно.'
                        , zfConvert_FloatToString (vbCriticalWeight)
                        , CHR(13)
                        , zfConvert_FloatToString (COALESCE ((SELECT SUM (_tmpItem.OperCount_Weight) FROM _tmpItem), 0))
                         ;*/
         outMessageText:= 'Сообщение.Разрешены заявки с общим весом >= ' || zfConvert_FloatToString (vbCriticalWeight) || ' кг.'
          --|| CHR(13) || 'Проведение заявки с весом = ' || zfConvert_FloatToString (COALESCE ((SELECT SUM (_tmpItem.OperCount_Weight) FROM _tmpItem), 0))  || ' кг. невозможно.'
            || CHR(13) || 'В текущей заявке вес = ' || zfConvert_FloatToString (COALESCE ((SELECT SUM (_tmpItem.OperCount_Weight) FROM _tmpItem), 0))  || ' кг.'
           ;

         -- !!! выход !!!
         RETURN;
      END IF;


     -- Расчеты сумм
     SELECT -- Расчет Итоговой суммы по Контрагенту
            CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE _tmpItem.tmpOperSumm_Partner
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но скидка/наценка учтена в цене!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
            END
            INTO vbOperSumm_Partner
     FROM (SELECT SUM (CASE WHEN _tmpItem.CountForPrice <> 0 THEN CAST ((_tmpItem.OperCount + _tmpItem.OperCount_Second) * _tmpItem.Price / _tmpItem.CountForPrice AS NUMERIC (16, 2))
                                                             ELSE CAST ((_tmpItem.OperCount + _tmpItem.OperCount_Second) * _tmpItem.Price AS NUMERIC (16, 2))
                        END) AS tmpOperSumm_Partner
           FROM (SELECT _tmpItem.Price
                      , _tmpItem.CountForPrice
                      , SUM (_tmpItem.OperCount)        AS OperCount
                      , SUM (_tmpItem.OperCount_Second) AS OperCount_Second
                 FROM _tmpItem
                 GROUP BY _tmpItem.GoodsId
                        , _tmpItem.GoodsKindId
                        , _tmpItem.Price
                        , _tmpItem.CountForPrice
                ) AS _tmpItem
          ) AS _tmpItem
     ;

     -- проверка - если не разрешен Минимальный заказ с суммой <
     IF vbSummOrderMin > 0 AND vbSummOrderMin > vbOperSumm_Partner
        AND vbIsLessWeigth = FALSE
        AND 1=0
     THEN
         outMessageText:= 'Сообщение.Разрешены заявки с суммой >= ' || zfConvert_FloatToString (vbSummOrderMin) || ' грн.'
          --|| CHR(13) || 'Проведение заявки с весом = ' || zfConvert_FloatToString (COALESCE ((SELECT SUM (_tmpItem.OperCount_Weight) FROM _tmpItem), 0))  || ' кг. невозможно.'
            || CHR(13) || 'В текущей заявке сумма = ' || zfConvert_FloatToString (vbOperSumm_Partner)  || ' грн.'
           ;

         -- !!! выход !!!
         RETURN;
      END IF;

     -- проверка
     IF inUserId = 5 AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка. %  %' , vbOperSumm_Partner , vbSummOrderMin;

     END IF;


     -- Расчет Итоговых сумм по Контрагенту (по элементам)
     SELECT SUM (_tmpItem.OperSumm_Partner) INTO vbOperSumm_Partner_byItem FROM _tmpItem;

     -- если не равны ДВЕ Итоговые суммы по Контрагенту
     IF COALESCE (vbOperSumm_Partner, 0) <> COALESCE (vbOperSumm_Partner_byItem, 0)
     THEN
         -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
         UPDATE _tmpItem SET OperSumm_Partner = OperSumm_Partner - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
         WHERE MovementItemId IN (SELECT MAX (MovementItemId) FROM _tmpItem WHERE OperSumm_Partner IN (SELECT MAX (OperSumm_Partner) FROM _tmpItem)
                                 );
     END IF;

     -- проверка
     IF EXISTS (SELECT _tmpItem.Price FROM _tmpItem WHERE _tmpItem.Price_original = 0) -- AND inUserId <> 5
   --IF EXISTS (SELECT _tmpItem.Price FROM _tmpItem WHERE _tmpItem.Price = 0) -- AND inUserId <> 5
           -- филиал Киев
       -- AND 8379 <> COALESCE ((SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 LIMIT 1), 0)
     THEN
         IF inUserId <> 5
         THEN outMessageText:= 'Ошибка.Документ сформирован но НЕ ПРОВЕДЕН'
                 -- || CHR(13) || 'Покупатель <' || lfGet_Object_ValueData (vbPartnerId) || '>.'
                 || CHR(13) || 'Для товара <' || (SELECT lfGet_Object_ValueData (_tmpItem.GoodsId) FROM _tmpItem WHERE _tmpItem.Price = 0 ORDER BY MovementItemId LIMIT 1) || '>'
                                      || ' <' || (SELECT lfGet_Object_ValueData (_tmpItem.GoodsKindId) FROM _tmpItem WHERE _tmpItem.Price = 0 ORDER BY MovementItemId LIMIT 1) || '>'
                 || CHR(13) || 'с количеством <' || zfConvert_FloatToString ((SELECT _tmpItem.OperCount FROM _tmpItem WHERE _tmpItem.Price = 0 ORDER BY MovementItemId LIMIT 1)) || '> установлена цена = 0.'
                 || CHR(13) || 'Необходимо открыть заявку № <' || COALESCE ((SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId), '') || '>'
                                                    || ' от <' || COALESCE ((SELECT DATE (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId) :: TVarChar, '') || '> и исправить цену.'
                 ;
         END IF;

         -- !!! выход !!!
         RETURN;

     END IF;

     -- проверка
     IF 1=0 AND EXISTS (SELECT 1 FROM _tmpItem WHERE 1 <= CASE WHEN _tmpItem.PriceEDI > 0 THEN 100 * ABS (_tmpItem.Price - _tmpItem.PriceEDI) / _tmpItem.PriceEDI ELSE 0 END)
     THEN
         outMessageText:= 'Ошибка.Документ сформирован но НЕ ПРОВЕДЕН'
            -- || CHR(13) || 'Покупатель <' || lfGet_Object_ValueData (vbPartnerId) || '>.'
            || CHR(13) || 'У товара <' || (SELECT lfGet_Object_ValueData (_tmpItem.GoodsId) FROM _tmpItem WHERE 1 <= CASE WHEN _tmpItem.PriceEDI > 0 THEN 100 * ABS (_tmpItem.Price - _tmpItem.PriceEDI) / _tmpItem.PriceEDI ELSE 0 END ORDER BY MovementItemId LIMIT 1) || '>'
                               || ' <' || (SELECT lfGet_Object_ValueData (_tmpItem.GoodsKindId) FROM _tmpItem WHERE 1 <= CASE WHEN _tmpItem.PriceEDI > 0 THEN 100 * ABS (_tmpItem.Price - _tmpItem.PriceEDI) / _tmpItem.PriceEDI ELSE 0 END ORDER BY MovementItemId LIMIT 1) || '>'
            || CHR(13) || 'цена = <' || zfConvert_FloatToString ((SELECT _tmpItem.Price FROM _tmpItem WHERE 1 <= CASE WHEN _tmpItem.PriceEDI > 0 THEN 100 * ABS (_tmpItem.Price - _tmpItem.PriceEDI) / _tmpItem.PriceEDI ELSE 0 END ORDER BY MovementItemId LIMIT 1)) || '>'
                       || 'не соответствует цене EDI = <' || zfConvert_FloatToString ((SELECT _tmpItem.PriceEDI FROM _tmpItem WHERE 1 <= CASE WHEN _tmpItem.PriceEDI > 0 THEN 100 * ABS (_tmpItem.Price - _tmpItem.PriceEDI) / _tmpItem.PriceEDI ELSE 0 END ORDER BY MovementItemId LIMIT 1)) || '>.'
            || CHR(13) || 'Необходимо открыть заявку № <' || COALESCE ((SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId), '') || '>'
                                               || ' от <' || COALESCE ((SELECT DATE (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId) :: TVarChar, '') || '> и исправить цену.'
            -- || CHR(13) || ' % <' || zfConvert_FloatToString ((SELECT CASE WHEN _tmpItem.PriceEDI > 0 THEN 100 * ABS (_tmpItem.Price * (1 + _tmpItem.ChangePercent / 100) /*- _tmpItem.PriceEDI*/) / 1 /*_tmpItem.PriceEDI*/ ELSE 0 END FROM _tmpItem WHERE 1 <= CASE WHEN _tmpItem.PriceEDI > 0 THEN 100 * ABS (_tmpItem.Price * (1 + _tmpItem.ChangePercent / 100) - _tmpItem.PriceEDI) / _tmpItem.PriceEDI ELSE 0 END ORDER BY MovementItemId LIMIT 1)) || '>'
            || CHR(13) || ' % <' || zfConvert_FloatToString ((SELECT CASE WHEN _tmpItem.PriceEDI > 0 THEN 100 * ABS (_tmpItem.Price - _tmpItem.PriceEDI) / _tmpItem.PriceEDI ELSE 0 END FROM _tmpItem WHERE 1 <= CASE WHEN _tmpItem.PriceEDI > 0 THEN 100 * ABS (_tmpItem.Price - _tmpItem.PriceEDI) / _tmpItem.PriceEDI ELSE 0 END ORDER BY MovementItemId LIMIT 1)) || '>'
              ;
         -- !!! выход !!!
         RETURN;
     END IF;


     -- !!!формируются свойства в элементах документа!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), _tmpItem.MovementItemId, _tmpItem.OperSumm_Partner)
     FROM _tmpItem;

     -- в MovementLinkMovement если найдена акция и она 1
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Promo(), inMovementId, CASE WHEN tmp.MovementId_min = tmp.MovementId_max THEN tmp.MovementId_min ELSE NULL END :: Integer)
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Promo(), inMovementId, CASE WHEN tmp.MovementId_min > 0 AND tmp.MovementId_max > 0 THEN TRUE ELSE FALSE END)
     FROM (SELECT 1 AS x) AS x1
           LEFT JOIN
          (SELECT MIN (MIFloat_PromoMovement.ValueData) AS MovementId_min,  MAX (MIFloat_PromoMovement.ValueData) AS MovementId_max
           FROM _tmpItem
                INNER JOIN MovementItemFloat AS MIFloat_PromoMovement
                                             ON MIFloat_PromoMovement.MovementItemId = _tmpItem.MovementItemId
                                            AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                                            AND MIFloat_PromoMovement.ValueData <> 0
          ) AS tmp ON 1 = 1;

     -- ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_OrderExternal()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.04.17                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM lpComplete_Movement_OrderExternal (inMovementId:= 579, inSession:= '2')
