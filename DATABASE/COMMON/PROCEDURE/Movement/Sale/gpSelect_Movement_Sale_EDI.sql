-- Function: gpSelect_Movement_Sale_EDI()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_EDI (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_EDI(
    IN inMovementId    Integer,    -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;

    DECLARE vbOperDate TDateTime;
    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
    DECLARE vbDiscountPercent TFloat;
    DECLARE vbExtraChargesPercent TFloat;
    DECLARE vbPaidKindId Integer;
    DECLARE vbContractId Integer;
    DECLARE vbIsLongUKTZED Boolean;

    DECLARE vbOperSumm_MVAT TFloat;
    DECLARE vbOperSumm_PVAT TFloat;
    DECLARE vbTotalCountKg  TFloat;
    DECLARE vbTotalCountSh  TFloat;
    
    DECLARE vbIsGoodsCode Boolean;

    DECLARE vbWeighingCount TFloat;

    DECLARE vbOperDate_insert TDateTime;
    DECLARE vbOperDatePartner TDateTime;

    DECLARE vbIsProcess_BranchIn Boolean;

    DECLARE vbStoreKeeperName TVarChar;
    
    DECLARE vbPartneFromId Integer;

    DECLARE vbUserSign TVarChar;
    DECLARE vbUserSeal TVarChar;
    DECLARE vbUserKey  TVarChar;

    DECLARE vbIsSchema_fozz_desadv Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

if vbUserId <> 5 AND 1=0
THEN
    RAISE EXCEPTION 'Ошибка.Нет прав.';
END IF;

     -- определяется - Крыхта Владимир Николаевич * м. Дніпро вул. Стартова 26
     vbPartneFromId := 258612;
     

     -- определяется Новая схема Сильпо - Desadv = BOXESQUANTITY (Кількість ящиків)
     vbIsSchema_fozz_desadv:= EXISTS (SELECT
                                      FROM MovementLinkObject AS MLO
                                      WHERE MLO.MovementId = inMovementId
                                        AND MLO.DescId = zc_MovementLinkObject_To()
                                        AND MLO.ObjectId IN (877319  -- 233022 - СІЛЬПО-ФУД ТОВ м. Запоріжжя вул. Базова буд.11
                                                           , 6523410 -- 242897 - СІЛЬПО-ФУД ТОВ с. Зимна Вода вул. Яворівська буд.30
                                                           , 877320  -- 233023 - СІЛЬПО-ФУД ТОВ с. Перемога вул. Б. Хмельницького буд.1
                                                           , 4498211 -- 239868 - СІЛЬПО-ФУД ТОВ с. Квітневе вул. Гоголівська буд.1 корп.А
                                                           , 877321  -- 233024 - СІЛЬПО-ФУД ТОВ п.р. Нерубайське вул. ***** буд.№11,№12,№13
                                                            )
                                     )
                          -- AND vbUserId <> 1329039  -- Авто-Загрузка EDI
                         ;


     -- определяется
     SELECT -- UserSign
            CASE WHEN vbUserId = 5 AND 1=0
                      THEN 'g:\Общие диски\keys\Эл_Ключи_ТОВ_АЛАН\НАГОРНОВА Т.С\24447183_2992217209_SU231208103427.ZS2'
                 WHEN ObjectString_UserSign.ValueData <> '' THEN ObjectString_UserSign.ValueData
                 ELSE '24447183_2992217209_SU231208103427.ZS2'
            END AS UserSign

            -- UserSeal
          , CASE WHEN vbUserId = 5 AND 1=0
                      THEN 'g:\Общие диски\keys\Эл_Ключи_ТОВ_АЛАН\ПЕЧАТЬ\24447183_U221220114928.ZS2'
                 WHEN ObjectString_UserSeal.ValueData <> '' THEN ObjectString_UserSeal.ValueData
                 ELSE '24447183_U221220114928.ZS2'
            END AS UserSeal

            -- UserKey
          , CASE WHEN vbUserId = 5 AND 1=0
                      THEN 'g:\Общие диски\keys\Эл_Ключи_ТОВ_АЛАН\ПЕЧАТЬ\24447183_U221220114928.ZS2'
                 WHEN ObjectString_UserKey.ValueData <> '' THEN ObjectString_UserKey.ValueData
                 ELSE '24447183_U221220114928.ZS2'
            END AS UserKey

            INTO vbUserSign, vbUserSeal, vbUserKey

     FROM Object AS Object_User
          LEFT JOIN ObjectString AS ObjectString_UserSign
                                 ON ObjectString_UserSign.DescId = zc_ObjectString_User_Sign() 
                                AND ObjectString_UserSign.ObjectId = Object_User.Id
          LEFT JOIN ObjectString AS ObjectString_UserSeal
                                 ON ObjectString_UserSeal.DescId = zc_ObjectString_User_Seal() 
                                AND ObjectString_UserSeal.ObjectId = Object_User.Id
          LEFT JOIN ObjectString AS ObjectString_UserKey 
                                 ON ObjectString_UserKey.DescId = zc_ObjectString_User_Key() 
                                AND ObjectString_UserKey.ObjectId = Object_User.Id
     WHERE Object_User.Id = vbUserId;


     -- параметры
     vbOperDate_insert:= (WITH tmp AS (SELECT MovementProtocol.Id, MovementProtocol.OperDate FROM MovementProtocol WHERE MovementProtocol.MovementId = inMovementId)
                          SELECT tmp.OperDate FROM tmp ORDER BY tmp.Id LIMIT 1
                         );
     -- параметр из документа
     vbOperDatePartner:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_OperDatePartner());
     -- параметры из Взвешивания
     vbStoreKeeperName:= (SELECT Object_User.ValueData
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                            ON MovementLinkObject_User.MovementId = Movement.Id
                                                           AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                               LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId
                          WHERE Movement.ParentId = inMovementId AND Movement.DescId IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                          LIMIT 1
                         );
     -- параметры из Взвешивания
     vbWeighingCount:= (SELECT Count(*) AS WeighingCount
                        FROM Movement
                        WHERE Movement.ParentId = inMovementId
                          AND Movement.DescId = zc_Movement_WeighingPartner()
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                       );


     -- Параметры - захардкодили
     SELECT -- ТОВАРИСТВО З ОБМЕЖЕНОЮ ВІДПОВІДАЛЬНІСТЮ"АРІТЕЙЛ"
            CASE WHEN OH_JuridicalDetails_To.OKPO = '41135005'
                      THEN TRUE
                      ELSE FALSE
            END AS isGoodsCode

            INTO vbIsGoodsCode

     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

          LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                              ON OH_JuridicalDetails_To.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId)
                                                             AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                             AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate
     WHERE Movement.Id     = inMovementId
       AND Movement.DescId <> zc_Movement_SendOnPrice()
     ;

     -- параметры из документа
     SELECT Movement.OperDate
          , Movement.DescId
          , Movement.StatusId
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END    AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END     AS ExtraChargesPercent
          , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId)) AS GoodsPropertyId
          , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)     AS GoodsPropertyId_basis
          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0)      AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0)      AS ContractId
          , COALESCE (ObjectBoolean_isLongUKTZED.ValueData, TRUE)   AS isLongUKTZED
            INTO vbOperDate, vbDescId, vbStatusId, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbGoodsPropertyId
               , vbGoodsPropertyId_basis, vbPaidKindId, vbContractId
               , vbIsLongUKTZED
     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                   ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindTo())

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isLongUKTZED
                                  ON ObjectBoolean_isLongUKTZED.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectBoolean_isLongUKTZED.DescId = zc_ObjectBoolean_Juridical_isLongUKTZED()
          /*LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId)
                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
          LEFT JOIN ObjectLink AS ObjectLink_JuridicalBasis_GoodsProperty
                               ON ObjectLink_JuridicalBasis_GoodsProperty.ObjectId = zc_Juridical_Basis()
                              AND ObjectLink_JuridicalBasis_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()*/
     WHERE Movement.Id = inMovementId AND Movement.DescId <> zc_Movement_SendOnPrice()
       -- AND Movement.StatusId = zc_Enum_Status_Complete()
    ;

     -- Важный параметр - Прихрд на филиала или расход с филиала (в первом слчае вводится только "Дата (приход)")
     vbIsProcess_BranchIn:= EXISTS (SELECT Id FROM Object_Unit_View WHERE Id = (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_To()) AND BranchId = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId))
                           ;

    -- очень важная проверка
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
       AND vbUserId <> 5
    THEN
        IF vbStatusId = zc_Enum_Status_Erased() -- AND inSession <> zfCalc_UserAdmin()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_SendOnPrice())
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не может участвовать в схеме EDI.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_SendOnPrice()), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        -- это уже странная ошибка
        RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;


    IF vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice()
    THEN
        -- Расчет Сумм
        SELECT CASE WHEN NOT vbPriceWithVAT OR vbVATPercent = 0
                         -- если цены без НДС или %НДС=0
                         THEN OperSumm
                    WHEN vbPriceWithVAT AND 1=1
                         -- если цены c НДС
                         THEN CAST ( (OperSumm) / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                    WHEN vbPriceWithVAT
                         -- если цены c НДС (Вариант может быть если первичен расчет НДС =1/6 )
                         THEN OperSumm - CAST ( (OperSumm) / (100 / vbVATPercent + 1) AS NUMERIC (16, 2))
               END AS OperSumm_MVAT
               -- Сумма с НДС
             , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                         -- если цены с НДС
                         THEN (OperSumm)
                    WHEN vbVATPercent > 0
                         -- если цены без НДС
                         THEN CAST ( (1 + vbVATPercent / 100) * (OperSumm) AS NUMERIC (16, 2))
               END AS OperSumm_PVAT
             , TotalCountKg
             , TotalCountSh

               INTO vbOperSumm_MVAT, vbOperSumm_PVAT
                  , vbTotalCountKg, vbTotalCountSh

        FROM
       (SELECT SUM (CASE WHEN tmpMI.CountForPrice <> 0
                              THEN CAST (tmpMI.Amount * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                         ELSE CAST (tmpMI.Amount * tmpMI.Price AS NUMERIC (16, 2))
                    END
                   ) AS OperSumm

                         -- ШТ
                       , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                   THEN tmpMI.Amount
                              ELSE 0
                         END) AS TotalCountSh
                         -- ВЕС
                       , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                   THEN tmpMI.Amount * COALESCE (ObjectFloat_Weight.ValueData, 0)
                              WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg()
                                   THEN tmpMI.Amount
                              ELSE 0
                         END) AS TotalCountKg

        FROM (SELECT MovementItem.ObjectId AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                   , CASE WHEN vbDiscountPercent <> 0
                               THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          WHEN vbExtraChargesPercent <> 0
                               THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          ELSE COALESCE (MIFloat_Price.ValueData, 0)
                     END AS Price
                   , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice
                   -- , SUM (MovementItem.Amount) AS Amount
                   , SUM (CASE WHEN Movement.DescId IN (zc_Movement_Sale())
                                    THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                               WHEN Movement.DescId IN (zc_Movement_SendOnPrice()) AND vbIsProcess_BranchIn = TRUE
                                    THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                               ELSE MovementItem.Amount
 
                          END) AS Amount
              FROM MovementItem
                   INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                ON MIFloat_Price.MovementItemId = MovementItem.Id
                                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                               -- AND MIFloat_Price.ValueData <> 0
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.isErased = FALSE
              GROUP BY MovementItem.ObjectId
                     , MILinkObject_GoodsKind.ObjectId
                     , MIFloat_Price.ValueData
                     , MIFloat_CountForPrice.ValueData
             ) AS tmpMI
                       LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                             ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                            AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                            ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                            ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                           AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                       LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
        ) AS tmpMI;
    END IF;



     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
   /*INSERT INTO ResourseProtocol (UserId
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
             , (CLOCK_TIMESTAMP() - CLOCK_TIMESTAMP()) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц ДО lpSelectMinPrice_List
             , NULL AS Time2
               -- сколько всего выполнялась проц lpSelectMinPrice_List
             , NULL AS Time3
               -- сколько всего выполнялась проц ПОСЛЕ lpSelectMinPrice_List
             , NULL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpSelect_Movement_Sale_EDI'
               -- ProtocolData
             , inMovementId :: TVarChar
    || ', ' || inSession
    || ', ' || (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
              ;*/


     --
    OPEN Cursor1 FOR
--     WITH tmpObject_GoodsPropertyValue AS
       WITH tmpTransport AS (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = inMovementId AND DescId = zc_MovementLinkMovement_TransportGoods())
          , tmpTransportGoods AS (SELECT * 
                                  FROM gpGet_Movement_TransportGoods (inMovementId       := (SELECT MovementChildId FROM tmpTransport)
                                                                    , inMovementId_Sale  := inMovementId
                                                                    , inOperDate         := NULL
                                                                    , inSession          := inSession
                                                                     )
                                  WHERE EXISTS (SELECT MovementChildId FROM tmpTransport)
                                 )
          , tmpObject_BankAccount_View AS (SELECT * FROM Object_BankAccount_View)
          , tmpObject_Bank_View AS (SELECT * FROM Object_Bank_View)

          , BankAccount_To AS (SELECT *
                               FROM tmpObject_BankAccount_View
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = inMovementId
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                              WHERE tmpObject_BankAccount_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                              LIMIT 1
                              )
          
          , tmpOH_JuridicalDetails_ViewByDate AS (SELECT * 
                                                  FROM ObjectHistory_JuridicalDetails_ViewByDate
                                                  )
          , tmpMovementFloat AS (SELECT *
                                 FROM MovementFloat
                                 WHERE MovementFloat.MovementId = inMovementId
                                   AND MovementFloat.DescId IN (zc_MovementFloat_TotalCount()
                                                              , zc_MovementFloat_TotalCountKg()
                                                              , zc_MovementFloat_TotalCountSh()
                                                              , zc_MovementFloat_TotalSummMVAT()
                                                              , zc_MovementFloat_TotalSummPVAT()
                                                              , zc_MovementFloat_TotalSumm()
                                                              )
                                 )

          , tmpMovementString AS (SELECT *
                                  FROM MovementString
                                  WHERE MovementString.MovementId = inMovementId
                                    AND MovementString.DescId IN (zc_MovementString_InvNumberOrder()
                                                                , zc_MovementString_InvNumberPartner()
                                                                 )
                                 )
                    
          , tmpMovementDate AS (SELECT *
                                FROM MovementDate
                                WHERE MovementDate.MovementId = inMovementId
                                  AND MovementDate.DescId IN (zc_MovementDate_Payment()
                                                            , zc_MovementDate_OperDatePartner()
                                                            )
                               )

          , tmpMovementLinkObject AS (SELECT *
                                      FROM MovementLinkObject
                                      WHERE MovementLinkObject.MovementId = inMovementId
                                        AND MovementLinkObject.DescId IN (zc_MovementLinkObject_Partner()
                                                                        , zc_MovementLinkObject_From()
                                                                        , zc_MovementLinkObject_ArticleLoss()
                                                                        , zc_MovementLinkObject_To()
                                                                        , zc_MovementLinkObject_RouteSorting()
                                                                        )
                                     )

          , tmpMovement AS (SELECT * FROM Movement WHERE Movement.Id = inMovementId AND (Movement.StatusId = zc_Enum_Status_Complete() OR vbUserId = 5))
       -- Результат
       SELECT
             Movement.Id                                AS Id
--           , Movement.InvNumber                         AS InvNumber
           , CASE WHEN Movement.DescId = zc_Movement_Sale()
                       THEN Movement.InvNumber
                  WHEN Movement.DescId = zc_Movement_TransferDebtOut() AND MovementString_InvNumberPartner.ValueData <> ''
                       THEN COALESCE (MovementString_InvNumberPartner.ValueData, Movement.InvNumber)
                  WHEN Movement.DescId = zc_Movement_TransferDebtOut() AND MovementString_InvNumberPartner.ValueData = ''
                       THEN Movement.InvNumber
                  ELSE Movement.InvNumber
             END AS InvNumber

           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
           , MovementString_DealId.ValueData            AS DealId
           , MovementString_DocumentId_vch.ValueData    AS DocumentId_vch
           , MovementString_VchasnoId.ValueData         AS VchasnoId

           , CASE WHEN MovementString_InvNumberPartner_order.ValueData <> ''
                       THEN MovementString_InvNumberPartner_order.ValueData
                  WHEN MovementString_InvNumberOrder.ValueData <> ''
                       THEN MovementString_InvNumberOrder.ValueData
                  ELSE COALESCE (Movement_order.InvNumber, '')
             END AS InvNumberOrder

           , Movement.OperDate                          AS OperDate
           , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)     AS OperDatePartner
           , MovementDate_Payment.ValueData             AS PaymentDate
           , CASE WHEN MovementDate_Payment.ValueData IS NOT NULL THEN TRUE ELSE FALSE END AS isPaymentDate
           , COALESCE (Movement_EDI.OperDate, COALESCE (Movement_order.OperDate, Movement.OperDate)) AS OperDateOrder

           , ObjectString_RoomNumber.ValueData                  AS INFO_RoomNumber

           , vbPriceWithVAT                             AS PriceWithVAT
           , vbVATPercent                               AS VATPercent
           , vbExtraChargesPercent - vbDiscountPercent  AS ChangePercent
           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice() THEN vbTotalCountKg ELSE MovementFloat_TotalCountKg.ValueData END AS TotalCountKg
           , CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice() THEN vbTotalCountSh ELSE MovementFloat_TotalCountSh.ValueData END AS TotalCountSh
           , CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice() THEN vbOperSumm_MVAT ELSE MovementFloat_TotalSummMVAT.ValueData END AS TotalSummMVAT
           , CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice() THEN vbOperSumm_PVAT ELSE MovementFloat_TotalSummPVAT.ValueData END AS TotalSummPVAT
           , CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice() THEN vbOperSumm_PVAT - vbOperSumm_MVAT ELSE MovementFloat_TotalSummPVAT.ValueData - MovementFloat_TotalSummMVAT.ValueData END AS SummVAT
           , CASE WHEN vbIsProcess_BranchIn = FALSE AND vbDescId = zc_Movement_SendOnPrice() THEN vbOperSumm_PVAT ELSE MovementFloat_TotalSumm.ValueData END AS TotalSumm
           , Object_From.ValueData             		AS FromName
           , COALESCE (Object_Partner.ValueData, Object_To.ValueData) AS ToName
           , Object_PaidKind.ValueData         		AS PaidKindName
           , View_Contract.InvNumber        		AS ContractName
           , ObjectDate_Signing.ValueData               AS ContractSigningDate
           , View_Contract.ContractKindName             AS ContractKind

           , Object_RouteSorting.ValueData 		        AS RouteSortingName

           , /*CASE WHEN View_Contract.InfoMoneyId = zc_Enum_InfoMoney_30101() AND Object_From.Id = 8459
                   AND OH_JuridicalDetails_To.OKPO NOT IN ('32516492', '39135315', '39622918')
                       THEN 'Бабенко В.П.'
                  ELSE ''
             END*/ vbStoreKeeperName AS StoreKeeper -- кладовщик
           , '' :: TVarChar                             AS Through     -- через кого
           , CASE WHEN OH_JuridicalDetails_To.OKPO IN ('32516492', '39135315', '39622918') THEN 'м. Київ, вул Ольжича, 18/22' ELSE '' END :: TVarChar  AS UnitAddress -- адреса складання

           , CASE WHEN ObjectLink_Contract_JuridicalDocument.ChildObjectId > 0 THEN TRUE ELSE FALSE END AS isJuridicalDocument

           , ObjectString_Partner_ShortName.ValueData   AS ShortNamePartner_To
           , ObjectString_ToAddress.ValueData           AS PartnerAddress_To
           --, Object_Street_View.CityName                AS CityName_To
           , Object_Street_View.PostalCode              AS PostalCode_To
           , COALESCE(ObjectString_CityKind_ShortName_To.ValueData||' ', '')||
             COALESCE (Object_Street_View.CityName, '')    AS CityName_To
                      
           , (CASE WHEN ObjectString_HouseNumber.ValueData <> '' THEN Object_Street_View.StreetKindName || ' ' ELSE '' END
             || Object_Street_View.Name
             || CASE WHEN ObjectString_HouseNumber.ValueData <> '' THEN ' д.' || ObjectString_HouseNumber.ValueData ELSE '' END
             ) :: TVarChar AS StreetName_To
           , OH_JuridicalDetails_To.JuridicalId         AS JuridicalId_To
           , COALESCE (Object_ArticleLoss.ValueData, OH_JuridicalDetails_To.FullName) AS JuridicalName_To
           , OH_JuridicalDetails_To.JuridicalAddress    AS JuridicalAddress_To
           , OH_JuridicalDetails_To.OKPO                AS OKPO_To
           , OH_JuridicalDetails_To.INN                 AS INN_To
           , OH_JuridicalDetails_To.NumberVAT           AS NumberVAT_To
           , OH_JuridicalDetails_To.AccounterName       AS AccounterName_To
           , OH_JuridicalDetails_To.BankAccount         AS BankAccount_To
           , OH_JuridicalDetails_To.BankName            AS BankName_To
           , OH_JuridicalDetails_To.MFO                 AS BankMFO_To
           , OH_JuridicalDetails_To.Phone               AS Phone_To
           --, CASE WHEN ObjectLink_Juridical_Retail.ChildObjectId = 310855 /*Варус*/ THEN ObjectString_Partner_GLNCode.ValueData ELSE ObjectString_Juridical_GLNCode.ValueData END AS BuyerGLNCode
           --, ObjectString_Partner_GLNCode.ValueData AS DeliveryPlaceGLNCode
           --, ObjectString_Partner_GLNCode.ValueData AS RecipientGLNCode

             -- GLN місця доставки
           , ObjectString_Partner_GLNCode.ValueData     AS DeliveryPlaceGLNCode

           /*, CASE WHEN ObjectString_Partner_GLNCodeJuridical.ValueData <> '' THEN ObjectString_Partner_GLNCodeJuridical.ValueData ELSE ObjectString_Juridical_GLNCode.ValueData END AS BuyerGLNCode
           , CASE WHEN ObjectString_Partner_GLNCodeRetail.ValueData <> '' THEN ObjectString_Partner_GLNCodeRetail.ValueData WHEN ObjectString_Retail_GLNCode.ValueData <> '' THEN ObjectString_Retail_GLNCode.ValueData ELSE ObjectString_Juridical_GLNCode.ValueData END AS RecipientGLNCode

           , CASE WHEN ObjectString_Partner_GLNCodeCorporate.ValueData <> '' THEN ObjectString_Partner_GLNCodeCorporate.ValueData ELSE ObjectString_JuridicalFrom_GLNCode.ValueData END AS SupplierGLNCode
           , CASE WHEN ObjectString_Partner_GLNCodeCorporate.ValueData <> '' THEN ObjectString_Partner_GLNCodeCorporate.ValueData ELSE ObjectString_JuridicalFrom_GLNCode.ValueData END AS SenderGLNCode*/

             -- GLN покупця
           , zfCalc_GLNCodeJuridical (inGLNCode                  := ObjectString_Partner_GLNCode.ValueData
                                    , inGLNCodeJuridical_partner := ObjectString_Partner_GLNCodeJuridical.ValueData
                                    , inGLNCodeJuridical         := ObjectString_Juridical_GLNCode.ValueData
                                     ) AS BuyerGLNCode

             -- GLN одержувача повідомлення
           , CASE WHEN Movement.InvNumber IN ('2183965', '2183964', '2183929', '2183925')
                       THEN '9991027029468'
                  ELSE zfCalc_GLNCodeRetail
                                  (inGLNCode               := ObjectString_Partner_GLNCode.ValueData
                                 , inGLNCodeRetail_partner := ObjectString_Partner_GLNCodeRetail.ValueData
                                 , inGLNCodeRetail         := ObjectString_Retail_GLNCode.ValueData
                                 , inGLNCodeJuridical      := ObjectString_Juridical_GLNCode.ValueData
                                  )
             END :: TVarChar AS RecipientGLNCode

           , CASE WHEN 1=0 AND OH_JuridicalDetails_To.JuridicalId = 15158 -- МЕТРО Кеш енд Кері Україна ТОВ
                       THEN '' -- если Метро, тогда наш = "пусто"
                  ELSE zfCalc_GLNCodeCorporate (inGLNCode                  := ObjectString_Partner_GLNCode.ValueData
                                              , inGLNCodeCorporate_partner := ObjectString_Partner_GLNCodeCorporate.ValueData
                                              , inGLNCodeCorporate_retail  := ObjectString_Retail_GLNCodeCorporate.ValueData
                                              , inGLNCodeCorporate_main    := ObjectString_JuridicalFrom_GLNCode.ValueData
                                               )
             END :: TVarChar AS SupplierGLNCode

           , zfCalc_GLNCodeCorporate (inGLNCode                  := ObjectString_Partner_GLNCode.ValueData
                                    , inGLNCodeCorporate_partner := ObjectString_Partner_GLNCodeCorporate.ValueData
                                    , inGLNCodeCorporate_retail  := ObjectString_Retail_GLNCodeCorporate.ValueData
                                    , inGLNCodeCorporate_main    := ObjectString_JuridicalFrom_GLNCode.ValueData
                                     ) AS SenderGLNCode

           , OH_JuridicalDetails_From.JuridicalId       AS JuridicalId_From
           , OH_JuridicalDetails_From.FullName          AS JuridicalName_From
           , OH_JuridicalDetails_From.JuridicalAddress  AS JuridicalAddress_From
           , OH_JuridicalDetails_From.OKPO              AS OKPO_From
           , OH_JuridicalDetails_From.INN               AS INN_From
           , OH_JuridicalDetails_From.NumberVAT         AS NumberVAT_From
           , OH_JuridicalDetails_From.AccounterName     AS AccounterName_From
           , OH_JuridicalDetails_From.BankAccount       AS BankAccount_From
           , OH_JuridicalDetails_From.BankName          AS BankName_From
           , OH_JuridicalDetails_From.MFO               AS BankMFO_From
           , OH_JuridicalDetails_From.Phone             AS Phone_From
           --, ObjectString_JuridicalFrom_GLNCode.ValueData     AS SupplierGLNCode
           --, ObjectString_JuridicalFrom_GLNCode.ValueData     AS SenderGLNCode

           , Object_BankAccount.Name                            AS BankAccount_ByContract
           , 'российских рублях' :: TVarChar                    AS CurrencyInternalAll_ByContract
           , Object_BankAccount.CurrencyInternalName            AS CurrencyInternal_ByContract
           , Object_BankAccount.BankName                        AS BankName_ByContract
           , Object_BankAccount.MFO                             AS BankMFO_ByContract
           , Object_BankAccount.SWIFT                           AS BankSWIFT_ByContract
           , Object_BankAccount.IBAN                            AS BankIBAN_ByContract
           , Object_BankAccount.CorrespondentBankName           AS CorrBankName_ByContract
           , Object_Bank_View_CorrespondentBank_From.SWIFT      AS CorrBankSWIFT_ByContract
           , Object_BankAccount.CorrespondentAccount            AS CorrespondentAccount_ByContract
           , OHS_JD_JuridicalAddress_Bank_From.ValueData        AS JuridicalAddressBankFrom
           , OHS_JD_JuridicalAddress_CorrBank_From.ValueData    AS JuridicalAddressCorrBankFrom


           , COALESCE(MovementLinkMovement_Sale.MovementChildId, 0)         AS EDIId

           , BankAccount_To.BankName                            AS BankName_Int
           , BankAccount_To.Name                                AS BankAccount_Int

           , BankAccount_To.CorrespondentBankName               AS CorBankName_Int
           , Object_Bank_View_CorrespondentBank.JuridicalName   AS CorBankJuridicalName_Int
           , Object_Bank_View_CorrespondentBank.SWIFT           AS CorBankSWIFT_Int

           , BankAccount_To.BeneficiarysBankName                AS BenefBankName_Int
           , OHS_JD_JuridicalAddress_BenifBank_To.ValueData     AS JuridicalAddressBenifBank_Int
           , Object_Bank_View_BenifBank.SWIFT                   AS BenifBankSWIFT_Int
           , BankAccount_To.BeneficiarysBankAccount             AS BenefBankAccount_Int

           , BankAccount_To.MFO                                 AS BankMFO_Int
           , BankAccount_To.SWIFT                               AS BankSWIFT_Int
           , BankAccount_To.IBAN                                AS BankIBAN_Int

           , Object_Bank_View_To.JuridicalName                  AS BankJuridicalName_Int
           , OHS_JD_JuridicalAddress_To.ValueData               AS BankJuridicalAddress_Int
           , BankAccount_To.BeneficiarysAccount                 AS BenefAccount_Int
           , BankAccount_To.Name                                AS BankAccount_Int

           , MS_InvNumberPartner_Master.ValueData           AS InvNumberPartner_Master

           , CASE WHEN (vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0) AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()
                        THEN ' та знижкой'
                  ELSE ''
             END :: TVarChar AS Price_info

             -- 14781 - № 7183Р
           , CASE WHEN vbContractId = 4440485 -- для договора Id = 4440485 + доп страничка\
                  --OR vbUserId = 5
                    OR (ObjectLink_Partner_Juridical.ChildObjectId = 862910 -- СІЛЬПО-ФУД ТОВ
                    AND vbUserId <> 1329039  -- Авто-Загрузка EDI
                    AND vbUserId <> 5 -- ???
                       )
                  THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isSchema_fozz

             -- Новая схема Сильпо - Desadv = BOXESQUANTITY (Кількість ящиків)
           , vbIsSchema_fozz_desadv :: Boolean AS isSchema_fozz_desadv

             --  новая схема
           , (OH_JuridicalDetails_To.OKPO = '32490244' -- ЕПІЦЕНТР К ТОВ
           OR OH_JuridicalDetails_To.OKPO = '44140683' -- Турбо. ЮА
         --OR (vbUserId = 5 AND OH_JuridicalDetails_To.OKPO = '43536406') -- Гловопром Україна
             ) :: Boolean AS isDOCUMENTINVOICE_DRN

           , tmpTransportGoods.CarName
           , tmpTransportGoods.CarModelName

           , vbOperDate_insert AS OperDate_insert
           , CASE WHEN vbWeighingCount > 0 THEN vbWeighingCount ELSE 1 END :: Integer AS WeighingCount
           
           , Object_Street_View_From.PostalCode     AS PostalCode_From

           , COALESCE(ObjectString_CityKind_ShortName_From.ValueData||' ', '')||
             COALESCE (Object_Street_View_From.CityName, '')    AS CityName_From

           , COALESCE(ObjectString_StreetKind_ShortName_From.ValueData||' ', '')||
             Object_Street_View_From.Name|| 
                              CASE WHEN COALESCE (ObjectString_HouseNumber_From.ValueData, '') <> ''
                                        THEN ' буд.' || COALESCE (ObjectString_HouseNumber_From.ValueData, '')
                                   ELSE ''
                              END ||
                              CASE WHEN COALESCE (ObjectString_CaseNumber_From.ValueData, '') <> ''
                                        THEN ' корп.' || COALESCE (ObjectString_CaseNumber_From.ValueData, '')
                                   ELSE ''
                              END  AS StreetName_From

           , vbUserSign AS UserSign
           , vbUserSeal AS UserSeal
           , vbUserKey  AS UserKey

       FROM tmpMovement AS Movement
            LEFT JOIN tmpTransportGoods ON tmpTransportGoods.MovementId_Sale = Movement.Id
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Sale
                                           ON MovementLinkMovement_Sale.MovementId = Movement.Id
                                          AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Sale()
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN Movement AS Movement_order ON Movement_order.Id = MovementLinkMovement_Order.MovementChildId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_order
                                     ON MovementString_InvNumberPartner_order.MovementId = Movement_order.Id
                                    AND MovementString_InvNumberPartner_order.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order_edi
                                           ON MovementLinkMovement_Order_edi.MovementId = Movement_order.Id
                                          AND MovementLinkMovement_Order_edi.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN Movement AS Movement_EDI ON Movement_EDI.Id = MovementLinkMovement_Order_edi.MovementChildId
            LEFT JOIN MovementString AS MovementString_DealId
                                     ON MovementString_DealId.MovementId = Movement_EDI.Id
                                    AND MovementString_DealId.DescId = zc_MovementString_DealId()
            LEFT JOIN MovementString AS MovementString_DocumentId_vch
                                     ON MovementString_DocumentId_vch.MovementId = Movement_EDI.Id
                                    AND MovementString_DocumentId_vch.DescId = zc_MovementString_DocumentId_vch()
            LEFT JOIN MovementString AS MovementString_VchasnoId
                                     ON MovementString_VchasnoId.MovementId = Movement_EDI.Id
                                    AND MovementString_VchasnoId.DescId = zc_MovementString_VchasnoId()

            LEFT JOIN tmpMovementString AS MovementString_InvNumberOrder
                                        ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                       AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
            LEFT JOIN tmpMovementDate AS MovementDate_Payment
                                      ON MovementDate_Payment.MovementId =  Movement.Id
                                     AND MovementDate_Payment.DescId = zc_MovementDate_Payment()
            LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                      ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                        ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                       AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCount
                                       ON MovementFloat_TotalCount.MovementId = Movement.Id
                                      AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountKg
                                       ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountSh
                                       ON MovementFloat_TotalCountSh.MovementId = Movement.Id
                                      AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummMVAT
                                       ON MovementFloat_TotalSummMVAT.MovementId = Movement.Id
                                      AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPVAT
                                       ON MovementFloat_TotalSummPVAT.MovementId = Movement.Id
                                      AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                       ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                      AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                AND vbContractId = 0

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_ArticleLoss
                                         ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                        AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
            LEFT JOIN Object AS Object_ArticleLoss ON Object_ArticleLoss.Id = MovementLinkObject_ArticleLoss.ObjectId
            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectString AS ObjectString_ToAddress
                                   ON ObjectString_ToAddress.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_ToAddress.DescId = zc_ObjectString_Partner_Address()
            LEFT JOIN ObjectString AS ObjectString_Partner_ShortName
                                   ON ObjectString_Partner_ShortName.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_Partner_ShortName.DescId = zc_ObjectString_Partner_ShortName()
            LEFT JOIN ObjectString AS ObjectString_HouseNumber
                                   ON ObjectString_HouseNumber.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_HouseNumber.DescId = zc_ObjectString_Partner_HouseNumber()
            LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                   ON ObjectString_RoomNumber.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_RoomNumber.DescId = zc_ObjectString_Partner_RoomNumber()
                                  AND ObjectString_RoomNumber.ValueData <> ''
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Street
                                 ON ObjectLink_Partner_Street.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                AND ObjectLink_Partner_Street.DescId = zc_ObjectLink_Partner_Street()
            LEFT JOIN Object_Street_View ON Object_Street_View.Id = ObjectLink_Partner_Street.ChildObjectId

            /*LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindTo())*/
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = vbPaidKindId -- MovementLinkObject_PaidKind.ObjectId
-- Contract
            /*LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())*/
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = vbContractId -- MovementLinkObject_Contract.ObjectId
            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = View_Contract.ContractId -- MovementLinkObject_Contract.ObjectId
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                AND View_Contract.InvNumber <> '-'
            LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                                 ON ObjectLink_Contract_JuridicalDocument.ObjectId = View_Contract.ContractId -- MovementLinkObject_Contract.ObjectId
                                AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
                                AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_RouteSorting
                                         ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                        AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN ObjectString AS ObjectString_Partner_GLNCode
                                   ON ObjectString_Partner_GLNCode.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_Partner_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
         LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeJuridical
                                ON ObjectString_Partner_GLNCodeJuridical.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                               AND ObjectString_Partner_GLNCodeJuridical.DescId = zc_ObjectString_Partner_GLNCodeJuridical()
         LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeRetail
                                ON ObjectString_Partner_GLNCodeRetail.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                               AND ObjectString_Partner_GLNCodeRetail.DescId = zc_ObjectString_Partner_GLNCodeRetail()
         LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeCorporate
                                ON ObjectString_Partner_GLNCodeCorporate.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                               AND ObjectString_Partner_GLNCodeCorporate.DescId = zc_ObjectString_Partner_GLNCodeCorporate()

            LEFT JOIN tmpOH_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                        ON OH_JuridicalDetails_To.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_To.Id)
                                                       AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                       AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode
                                   ON ObjectString_Juridical_GLNCode.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                  AND ObjectString_Juridical_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()
            LEFT JOIN ObjectString AS ObjectString_Retail_GLNCode
                                   ON ObjectString_Retail_GLNCode.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                  AND ObjectString_Retail_GLNCode.DescId = zc_ObjectString_Retail_GLNCode()
            LEFT JOIN ObjectString AS ObjectString_Retail_GLNCodeCorporate
                                   ON ObjectString_Retail_GLNCodeCorporate.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                  AND ObjectString_Retail_GLNCodeCorporate.DescId = zc_ObjectString_Retail_GLNCodeCorporate()

            LEFT JOIN tmpOH_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                        ON OH_JuridicalDetails_From.JuridicalId = COALESCE (ObjectLink_Contract_JuridicalDocument.ChildObjectId
                                                                                                , COALESCE (View_Contract.JuridicalBasisId
                                                                                                , COALESCE (ObjectLink_Unit_Juridical.ChildObjectId
                                                                                                          , Object_From.Id)))
                                                       AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                       AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_From.EndDate
            LEFT JOIN ObjectString AS ObjectString_JuridicalFrom_GLNCode
                                   ON ObjectString_JuridicalFrom_GLNCode.ObjectId = OH_JuridicalDetails_From.JuridicalId
                                  AND ObjectString_JuridicalFrom_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

-- bank account
            LEFT JOIN ObjectLink AS ObjectLink_Contract_BankAccount
                                 ON ObjectLink_Contract_BankAccount.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_BankAccount.DescId = zc_ObjectLink_Contract_BankAccount()

            LEFT JOIN ObjectLink AS ObjectLink_BankAccountContract_InfoMoney
                                 ON ObjectLink_BankAccountContract_InfoMoney.DescId = zc_ObjectLink_BankAccountContract_InfoMoney()
                                AND ObjectLink_BankAccountContract_InfoMoney.ChildObjectId = View_Contract.InfoMoneyId
                                AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL
            LEFT JOIN ObjectLink AS ObjectLink_BankAccountContract_BankAccount
                                 ON ObjectLink_BankAccountContract_BankAccount.DescId = zc_ObjectLink_BankAccountContract_BankAccount()
                                AND ObjectLink_BankAccountContract_BankAccount.ObjectId = ObjectLink_BankAccountContract_InfoMoney.ObjectId
            LEFT JOIN (SELECT ObjectLink_BankAccountContract_BankAccount.ChildObjectId
                       FROM ObjectLink AS ObjectLink_BankAccountContract_InfoMoney
                            JOIN ObjectLink AS ObjectLink_BankAccountContract_BankAccount
                                                 ON ObjectLink_BankAccountContract_BankAccount.DescId = zc_ObjectLink_BankAccountContract_BankAccount()
                                                AND ObjectLink_BankAccountContract_BankAccount.ObjectId = ObjectLink_BankAccountContract_InfoMoney.ObjectId
                                                AND ObjectLink_BankAccountContract_BankAccount.ChildObjectId IS NOT NULL
                            JOIN ObjectLink AS ObjectLink_BankAccountContract_Unit
                                                 ON ObjectLink_BankAccountContract_Unit.DescId = zc_ObjectLink_BankAccountContract_Unit()
                                                AND ObjectLink_BankAccountContract_Unit.ObjectId = ObjectLink_BankAccountContract_InfoMoney.ObjectId
                                                AND ObjectLink_BankAccountContract_Unit.ChildObjectId IS NULL

                       WHERE ObjectLink_BankAccountContract_InfoMoney.DescId = zc_ObjectLink_BankAccountContract_InfoMoney()
                         AND ObjectLink_BankAccountContract_InfoMoney.ChildObjectId IS NULL
                      ) AS ObjectLink_BankAccountContract_BankAccount_all ON ObjectLink_BankAccountContract_BankAccount.ChildObjectId IS NULL -- !!!не ошибка!!!, выбирается с пустой УП
                                                                         AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL

            LEFT JOIN tmpObject_BankAccount_View AS Object_BankAccount ON Object_BankAccount.Id = COALESCE (ObjectLink_Contract_BankAccount.ChildObjectId, COALESCE (ObjectLink_BankAccountContract_BankAccount.ChildObjectId, ObjectLink_BankAccountContract_BankAccount_all.ChildObjectId))


            LEFT JOIN tmpOH_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_Bank_From
                                                        ON OH_JuridicalDetails_Bank_From.JuridicalId = Object_BankAccount.BankJuridicalId
                                                       AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_Bank_From.StartDate 
                                                       AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_Bank_From.EndDate

            LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_Bank_From
                                          ON OHS_JD_JuridicalAddress_Bank_From.ObjectHistoryId = OH_JuridicalDetails_Bank_From.ObjectHistoryId
                                         AND OHS_JD_JuridicalAddress_Bank_From.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()

            LEFT JOIN tmpObject_Bank_View AS Object_Bank_View_CorrespondentBank_From ON Object_Bank_View_CorrespondentBank_From.Id = Object_BankAccount.CorrespondentBankId

            LEFT JOIN tmpOH_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_CorrBank_From
                                                                ON OH_JuridicalDetails_CorrBank_From.JuridicalId = Object_Bank_View_CorrespondentBank_From.JuridicalId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_CorrBank_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_CorrBank_From.EndDate

            LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_CorrBank_From
                                          ON OHS_JD_JuridicalAddress_CorrBank_From.ObjectHistoryId = OH_JuridicalDetails_CorrBank_From.ObjectHistoryId
                                         AND OHS_JD_JuridicalAddress_CorrBank_From.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()

-- +++++++++++++++++ BANK TO
            LEFT JOIN BankAccount_To ON 1=1

            LEFT JOIN tmpObject_Bank_View AS Object_Bank_View_CorrespondentBank ON Object_Bank_View_CorrespondentBank.Id = BankAccount_To.CorrespondentBankId
            LEFT JOIN tmpObject_Bank_View AS Object_Bank_View_BenifBank ON Object_Bank_View_BenifBank.Id = BankAccount_To.BeneficiarysBankId
            LEFT JOIN tmpObject_Bank_View AS Object_Bank_View_To ON Object_Bank_View_To.Id = BankAccount_To.BankId

            LEFT JOIN tmpOH_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_BenifBank_To
                                                        ON OH_JuridicalDetails_BenifBank_To.JuridicalId = Object_Bank_View_BenifBank.JuridicalId
                                                       AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_BenifBank_To.StartDate
                                                       AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) < OH_JuridicalDetails_BenifBank_To.EndDate

            LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_BenifBank_To
                                          ON OHS_JD_JuridicalAddress_BenifBank_To.ObjectHistoryId = OH_JuridicalDetails_BenifBank_To.ObjectHistoryId
                                         AND OHS_JD_JuridicalAddress_BenifBank_To.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()


            LEFT JOIN tmpOH_JuridicalDetails_ViewByDate AS OH_JuridicalDetailsBank_To
                                                        ON OH_JuridicalDetailsBank_To.JuridicalId = Object_Bank_View_To.JuridicalId
                                                       AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetailsBank_To.StartDate
                                                       AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetailsBank_To.EndDate

            LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_To
                                          ON OHS_JD_JuridicalAddress_To.ObjectHistoryId = OH_JuridicalDetailsBank_To.ObjectHistoryId
                                         AND OHS_JD_JuridicalAddress_To.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()

--
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                           ON MovementLinkMovement_Master.MovementId = Movement.Id
                                          AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN MovementString AS MS_InvNumberPartner_Master ON MS_InvNumberPartner_Master.MovementId = MovementLinkMovement_Master.MovementChildId
                                                                  AND MS_InvNumberPartner_Master.DescId = zc_MovementString_InvNumberPartner()
                                                                  
            LEFT JOIN ObjectString AS ObjectString_HouseNumber_From
                                   ON ObjectString_HouseNumber_From.ObjectId = vbPartneFromId
                                  AND ObjectString_HouseNumber_From.DescId = zc_ObjectString_Partner_HouseNumber()
            LEFT JOIN ObjectString AS ObjectString_CaseNumber_From
                                   ON ObjectString_CaseNumber_From.ObjectId = vbPartneFromId
                                  AND ObjectString_CaseNumber_From.DescId = zc_ObjectString_Partner_CaseNumber()

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Street_From
                                 ON ObjectLink_Partner_Street_From.ObjectId = vbPartneFromId
                                AND ObjectLink_Partner_Street_From.DescId = zc_ObjectLink_Partner_Street()
            LEFT JOIN Object_Street_View AS Object_Street_View_From
                                         ON Object_Street_View_From.Id = ObjectLink_Partner_Street_From.ChildObjectId
            LEFT JOIN ObjectString AS ObjectString_StreetKind_ShortName_From
                                   ON ObjectString_StreetKind_ShortName_From.ObjectId = Object_Street_View_From.StreetKindId
                                  AND ObjectString_StreetKind_ShortName_From.DescId = zc_ObjectString_StreetKind_ShortName()
                                  AND ObjectString_StreetKind_ShortName_From.ValueData <> ''

            LEFT JOIN ObjectLink AS ObjectLink_City_CityKind_From
                                 ON ObjectLink_City_CityKind_From.ObjectId = Object_Street_View_From.CityId
                                AND ObjectLink_City_CityKind_From.DescId = zc_ObjectLink_City_CityKind()
            LEFT JOIN ObjectString AS ObjectString_CityKind_ShortName_From
                                   ON ObjectString_CityKind_ShortName_From.ObjectId = ObjectLink_City_CityKind_From.ChildObjectId
                                  AND ObjectString_CityKind_ShortName_From.DescId = zc_ObjectString_CityKind_ShortName()
                                  AND ObjectString_CityKind_ShortName_From.ValueData <> ''

            LEFT JOIN ObjectLink AS ObjectLink_City_CityKind_To
                                 ON ObjectLink_City_CityKind_To.ObjectId = Object_Street_View.CityId
                                AND ObjectLink_City_CityKind_To.DescId = zc_ObjectLink_City_CityKind()
            LEFT JOIN ObjectString AS ObjectString_CityKind_ShortName_To
                                   ON ObjectString_CityKind_ShortName_To.ObjectId = ObjectLink_City_CityKind_To.ChildObjectId
                                  AND ObjectString_CityKind_ShortName_To.DescId = zc_ObjectString_CityKind_ShortName()
                                  AND ObjectString_CityKind_ShortName_To.ValueData <> ''

       WHERE Movement.Id = inMovementId
         AND (Movement.StatusId = zc_Enum_Status_Complete() OR vbUserId = 5)
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
     WITH tmpObject_GoodsPropertyValue AS
       (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectFloat_Amount.ValueData         AS Amount
             , ObjectString_BarCode.ValueData       AS BarCode
             , ObjectString_Article.ValueData       AS Article
             , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
             , ObjectString_ArticleGLN.ValueData    AS ArticleGLN
        FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                   ON ObjectFloat_Amount.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()

             LEFT JOIN ObjectString AS ObjectString_BarCode
                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()

             LEFT JOIN ObjectString AS ObjectString_BarCodeGLN
                                    ON ObjectString_BarCodeGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCodeGLN.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeGLN()
             LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                    ON ObjectString_ArticleGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )
     , tmpObject_GoodsPropertyValueGroup AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.Article
             , tmpObject_GoodsPropertyValue.ArticleGLN
             , tmpObject_GoodsPropertyValue.BarCode
             , tmpObject_GoodsPropertyValue.BarCodeGLN
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Article <> '' OR ArticleGLN <> '' OR BarCodeGLN <> '' GROUP BY GoodsId
             ) AS tmpGoodsProperty_find
             LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
       )
     , tmpObject_GoodsPropertyValue_basis AS
       (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
        FROM (SELECT vbGoodsPropertyId_basis AS GoodsPropertyId
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             INNER JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                           AND Object_GoodsPropertyValue.ValueData <> ''
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )
     , tmpMI_Order AS (SELECT MovementItem.ObjectId                         AS GoodsId
                            , SUM (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS Amount
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                            , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                            , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                       FROM (SELECT MovementLinkMovement_Order.MovementChildId AS MovementId
                             FROM MovementLinkMovement AS MovementLinkMovement_Order
                             WHERE MovementLinkMovement_Order.MovementId = inMovementId
                               AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                            ) AS tmpMovement
                            INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                       GROUP BY MovementItem.ObjectId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                              , COALESCE (MIFloat_Price.ValueData, 0)
                              , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                         )
 , tmpMI AS (SELECT MovementItem.ObjectId AS GoodsId
                  , ObjectLink_GoodsGroup.ChildObjectId AS GoodsGroupId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  , CASE WHEN vbDiscountPercent <> 0 AND vbPaidKindId <> zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                              THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                         WHEN vbExtraChargesPercent <> 0 AND vbPaidKindId <> zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                              THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                         ELSE COALESCE (MIFloat_Price.ValueData, 0)
                    END AS Price
                  , MIFloat_CountForPrice.ValueData AS CountForPrice
                  , SUM (MovementItem.Amount) AS Amount
                  , SUM (CASE WHEN Movement.DescId IN (zc_Movement_Sale())
                                   THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                              WHEN Movement.DescId IN (zc_Movement_SendOnPrice()) AND vbIsProcess_BranchIn = TRUE
                                   THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                              ELSE MovementItem.Amount

                         END) AS AmountPartner

                    -- Новая схема Сильпо - Desadv = BOXESQUANTITY (Кількість ящиків)
                  , SUM (CASE WHEN vbIsSchema_fozz_desadv = TRUE THEN COALESCE (MIFloat_BoxCount.ValueData, 0) ELSE 0 END) AS Count_Box_fozz

             FROM MovementItem
                  INNER JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                              AND MIFloat_Price.ValueData <> 0
                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                  LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                  -- Новая схема Сильпо - Desadv = BOXESQUANTITY (Кількість ящиків)
                  LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                              ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                             AND MIFloat_BoxCount.DescId         = zc_MIFloat_BoxCount()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                       ON ObjectLink_GoodsGroup.ObjectId = MovementItem.ObjectId
                                      AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Master()
               AND MovementItem.isErased   = FALSE
             GROUP BY MovementItem.ObjectId
                    , ObjectLink_GoodsGroup.ChildObjectId
                    , MILinkObject_GoodsKind.ObjectId
                    , MIFloat_Price.ValueData
                    , MIFloat_CountForPrice.ValueData
            )
      -- на дату
    , tmpUKTZED AS (SELECT tmp.GoodsGroupId, lfGet_Object_GoodsGroup_CodeUKTZED_onDate (tmp.GoodsGroupId, vbOperDatePartner) AS CodeUKTZED
                    FROM (SELECT DISTINCT tmpMI.GoodsGroupId FROM tmpMI) AS tmp)
       -- 
      SELECT COALESCE (Object_GoodsByGoodsKind_View.Id, Object_Goods.Id) AS Id
           , Object_Goods.ObjectCode         AS GoodsCode
           , (CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END) :: TVarChar AS GoodsName
           , CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END AS GoodsName_two
           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName
           , OS_Measure_InternalCode.ValueData  AS MeasureIntCode
           , CASE Object_Measure.Id
                  WHEN zc_Measure_Sh() THEN 'PCE'
                  ELSE 'KGM'
             END::TVarChar                   AS DELIVEREDUNIT
           , CASE -- на дату у товара
                  WHEN ObjectString_Goods_UKTZED_new.ValueData <> '' AND ObjectDate_Goods_UKTZED_new.ValueData <= vbOperDatePartner
                       THEN CASE WHEN vbIsLongUKTZED = TRUE THEN ObjectString_Goods_UKTZED_new.ValueData ELSE SUBSTRING (ObjectString_Goods_UKTZED_new.ValueData FROM 1 FOR 4) END
                  -- у товара
                  WHEN ObjectString_Goods_UKTZED.ValueData <> ''
                       THEN CASE WHEN vbIsLongUKTZED = TRUE THEN ObjectString_Goods_UKTZED.ValueData ELSE SUBSTRING (ObjectString_Goods_UKTZED.ValueData FROM 1 FOR 4) END
                  -- на дату у группы товара
                  WHEN tmpUKTZED.CodeUKTZED <> ''
                       THEN CASE WHEN vbIsLongUKTZED = TRUE THEN tmpUKTZED.CodeUKTZED ELSE SUBSTRING (tmpUKTZED.CodeUKTZED FROM 1 FOR 4) END

                  WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101())
                       THEN '1601'
                  WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_21001(), zc_Enum_InfoMoney_30102())
                       THEN '1602'
                  WHEN ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30103()
                       THEN '1905'
                  ELSE '0'
              END :: TVarChar AS GoodsCodeUKTZED

           , vbVATPercent                    AS VATPercent

           , tmpMI.Amount                    AS Amount
           , tmpMI.AmountPartner             AS AmountPartner
             -- Замовлена кількість
           , tmpMI_Order.Amount              AS AmountOrder
             -- Новая схема Сильпо - Desadv = BOXESQUANTITY (Кількість ящиків)
           , tmpMI.Count_Box_fozz :: TFloat AS Count_Box_fozz

           , tmpMI.Price                     AS Price
           , tmpMI.CountForPrice             AS CountForPrice

           , COALESCE (tmpObject_GoodsPropertyValue.Name, '')       AS GoodsName_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.Amount, 0)      AS AmountInPack_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.Article,    COALESCE (tmpObject_GoodsPropertyValue.Article, ''))    AS Article_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.BarCode,    COALESCE (tmpObject_GoodsPropertyValue.BarCode, ''))    AS BarCode_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.ArticleGLN, COALESCE (tmpObject_GoodsPropertyValue.ArticleGLN, '')) AS ArticleGLN_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.BarCodeGLN, COALESCE (tmpObject_GoodsPropertyValue.BarCodeGLN, '')) AS BarCodeGLN_Juridical

           , CASE WHEN vbGoodsPropertyId = 83954 -- Метро
                       THEN COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, ''))
                  ELSE ''
             END AS Article_order

             -- сумма по ценам док-та
           , CASE WHEN tmpMI.CountForPrice <> 0
                       THEN CAST (tmpMI.AmountPartner * (tmpMI.Price / tmpMI.CountForPrice) AS NUMERIC (16, 2))
                  ELSE CAST (tmpMI.AmountPartner * tmpMI.Price AS NUMERIC (16, 2))
             END AS AmountSumm

             -- расчет цены без НДС, до 4 знаков
           , CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 4))
                  ELSE tmpMI.Price
             END  / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceNoVAT

             -- расчет цены с НДС и скидкой, до 4 знаков
           , CASE WHEN vbPriceWithVAT <> TRUE
                  THEN CAST ((tmpMI.Price + tmpMI.Price * (vbVATPercent / 100))
                                         * CASE WHEN vbDiscountPercent <> 0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ учитываем!!!
                                                     THEN (1 - vbDiscountPercent / 100)
                                                WHEN vbExtraChargesPercent <> 0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ учитываем!!!
                                                     THEN (1 + vbExtraChargesPercent / 100)
                                                ELSE 1
                                           END
                             AS NUMERIC (16, 4))
                  ELSE CAST (tmpMI.Price * CASE WHEN vbDiscountPercent <> 0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                                                     THEN (1 - vbDiscountPercent / 100)
                                                WHEN vbExtraChargesPercent <> 0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                                                     THEN (1 + vbExtraChargesPercent / 100)
                                                ELSE 1
                                           END
                             AS NUMERIC (16, 4))
             END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceWVAT
             -- расчет цены с НДС БЕЗ скидки, до 4 знаков
           , CASE WHEN vbPriceWithVAT <> TRUE
                  THEN CAST ((tmpMI.Price + tmpMI.Price * (vbVATPercent / 100))
                                         * 1
                             AS NUMERIC (16, 4))
                  ELSE CAST (tmpMI.Price * 1
                             AS NUMERIC (16, 4))
             END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceWVAT_original

             -- расчет суммы без НДС, до 2 знаков
           , CAST (tmpMI.AmountPartner * CASE WHEN vbPriceWithVAT = TRUE
                                              THEN (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100)))
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 2)) AS AmountSummNoVAT

             -- расчет суммы с НДС, до 3 знаков
           , CAST (tmpMI.AmountPartner * CASE WHEN vbPriceWithVAT <> TRUE
                                              THEN tmpMI.Price + tmpMI.Price * (vbVATPercent / 100)
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 3)) AS AmountSummWVAT

           , CAST ((tmpMI.AmountPartner * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END )) AS TFloat) AS Amount_Weight
--           , CAST ((CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpMI.AmountPartner ELSE 0 END) AS TFloat) AS Amount_Sh

       FROM tmpMI

            LEFT JOIN tmpUKTZED ON tmpUKTZED.GoodsGroupId = tmpMI.GoodsGroupId
            LEFT JOIN tmpMI_Order ON tmpMI_Order.GoodsId     = tmpMI.GoodsId
                                 AND tmpMI_Order.GoodsKindId = tmpMI.GoodsKindId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN ObjectString AS ObjectString_Goods_BUH
                                   ON ObjectString_Goods_BUH.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_BUH.DescId = zc_ObjectString_Goods_BUH()
            LEFT JOIN ObjectDate AS ObjectDate_BUH
                                 ON ObjectDate_BUH.ObjectId = tmpMI.GoodsId
                                AND ObjectDate_BUH.DescId = zc_ObjectDate_Goods_BUH()

            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED
                                   ON ObjectString_Goods_UKTZED.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_UKTZED.DescId = zc_ObjectString_Goods_UKTZED()
            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED_new
                                   ON ObjectString_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_UKTZED_new.DescId = zc_ObjectString_Goods_UKTZED_new()
            LEFT JOIN ObjectDate AS ObjectDate_Goods_UKTZED_new
                                 ON ObjectDate_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                                AND ObjectDate_Goods_UKTZED_new.DescId = zc_ObjectDate_Goods_UKTZED_new()

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
            LEFT JOIN ObjectString AS OS_Measure_InternalCode
                                   ON OS_Measure_InternalCode.ObjectId = Object_Measure.Id
                                  AND OS_Measure_InternalCode.DescId = zc_ObjectString_Measure_InternalCode()



            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId
                                                  AND (tmpObject_GoodsPropertyValue.Article <> ''
                                                    OR tmpObject_GoodsPropertyValue.ArticleGLN <> ''
                                                    OR tmpObject_GoodsPropertyValue.Name <> '')
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = tmpMI.GoodsId
                                                       AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = tmpMI.GoodsId
                                                        AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = tmpMI.GoodsKindId

            LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = Object_Goods.Id
                                                  AND Object_GoodsByGoodsKind_View.GoodsKindId = Object_GoodsKind.Id

       WHERE tmpMI.AmountPartner <> 0
       ORDER BY CASE WHEN vbGoodsPropertyId IN (83954  -- Метро
                                              , 83963  -- Ашан
                                              , 404076 -- Новус
                                              , 83956  -- Фора
                                               )
                          THEN zfConvert_StringToNumber (COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, '0')))
                     ELSE '0'
                END :: Integer
              , CASE WHEN vbIsGoodsCode = TRUE THEN Object_Goods.ObjectCode ELSE 0 END
              , CASE WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate >= ObjectDate_BUH.ValueData THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData END
              , Object_GoodsKind.ValueData
              , Object_Goods.ValueData, Object_GoodsKind.ValueData
       ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.07.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Sale_EDI (inMovementId:= 30866920, inSession:=  '5'); -- FETCH ALL "<unnamed portal 1>";
