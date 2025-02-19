-- Function: gpSelect_Movement_Tax_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Tax_Print (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Tax_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inisClientCopy      Boolean  , -- копия для клиента
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE Cursor3 refcursor;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;

    DECLARE vbMovementId_Sale Integer;
    DECLARE vbMovementId_Tax Integer;
    DECLARE vbStatusId_Tax Integer;
    DECLARE vbDocumentTaxKindId Integer;
    DECLARE vbIsLongUKTZED Boolean;

    DECLARE vbCurrencyPartnerId Integer;

    DECLARE vbOperDate_begin   TDateTime;
    DECLARE vbOperDate_rus     TDateTime;
    DECLARE vbOperDate_Tax_Tax TDateTime;

    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;

    DECLARE vbNotNDSPayer_INN  TVarChar;
    DECLARE vbCalcNDSPayer_INN TVarChar;

   DECLARE vbUserSign TVarChar;
   DECLARE vbUserSeal TVarChar;
   DECLARE vbUserKey  TVarChar;

    DECLARE vbGoods_DocumentTaxKind       TVarChar;
    DECLARE vbMeasure_DocumentTaxKind     TVarChar;
    DECLARE vbMeasureCode_DocumentTaxKind TVarChar;
    DECLARE vbPrice_DocumentTaxKind       TVarChar;

    DECLARE vbOperDate_Begin1 TDateTime;
    DECLARE vbInfoMoneyId Integer;
BEGIN
     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_Begin1:= CLOCK_TIMESTAMP();

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!хардкод!!!
     vbNotNDSPayer_INN := '100000000000';
     -- !!!хардкод!!!
     vbCalcNDSPayer_INN:= (SELECT CASE WHEN inMovementId IN (-- Tax
                                                             6922620
                                                           , 6922564
                                                           , 6922609
                                                           , 6922233
                                                           , 6921599
                                                           , 6922367
                                                           , 6922254
                                                           , 6922275
                                                           , 8484674
                                                           , 8486085
                                                           , 8486839
                                                           , 8487001
                                                           , 8487359
                                                            )
                                  THEN vbNotNDSPayer_INN
                                  ELSE ''
                           END);
/*SELECT Movement.*, MovementString_InvNumberPartner.ValueData, OH_JuridicalDetails_To.INN
                           FROM Movement
                                LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                         ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                                        AND MovementString_InvNumberPartner.DescId     = zc_MovementString_InvNumberPartner()
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                                             -- AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                            AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_From()
                                LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                                    ON OH_JuridicalDetails_To.JuridicalId = MovementLinkObject_To.ObjectId
                                                                                   AND Movement.OperDate >= OH_JuridicalDetails_To.StartDate AND Movement.OperDate < OH_JuridicalDetails_To.EndDate
                           -- WHERE Movement.DescId = zc_Movement_Tax()
                           WHERE Movement.DescId = zc_Movement_TaxCorrective()
-- and Movement.OperDate BETWEEN '01.08.2017' AND '01.01.2018'
and (Movement.OperDate BETWEEN '01.12.2017' AND '01.01.2018'
or Movement.OperDate BETWEEN '01.02.2018' AND '02.02.2018')
                                        AND TRIM (OH_JuridicalDetails_To.INN) IN ('416995514032'
                                                                         , '2642315140'
                                                                 --        , '100000000000'
                                                )
                                        AND MovementString_InvNumberPartner.ValueData IN ('13015'
                                                                                         ,'13016'
                                                                                         ,'8190'
                                                                                         ,'8185'
                                                                                         ,'8183'
                                                                                         ,'4787'
                                                                                         ,'11995'
                                                                                         ,'11994'
                                                                                         ,'11993'
                                                                                         ,'12959'
                                                                                         ,'12957'
                                                                                         ,'14513'
                                                                                         ,'14514'
                                                                                         )
                                        AND MovementString_InvNumberPartner.ValueData IN ('5383'
                                                                                         ,'5402'
                                                                                         ,'5408'
                                                                                         ,'5418'
                                                                                         ,'5780'
                                                                                         ,'5972'
                                                                                         ,'5971'
                                                                                         ,'5974'
                                                                                         ,'6202'
                                                                                         ,'8629'
                                                                                         ,'13971'
                                                                                         ,'13972'
                                                                                         ,'13973'
                                                                                         )

order by 4*/


     -- определяется
     SELECT CASE WHEN ObjectString_UserSign.ValueData <> '' THEN ObjectString_UserSign.ValueData ELSE 'Ключ - Неграш О.В..ZS2'                                                   END AS UserSign
          , CASE WHEN ObjectString_UserSeal.ValueData <> '' THEN ObjectString_UserSeal.ValueData ELSE 'Ключ - для в_дтиску - Товариство з обмеженою в_дпов_дальн_стю АЛАН.ZS2'   END AS UserSeal
          , CASE WHEN ObjectString_UserKey.ValueData  <> '' THEN ObjectString_UserKey.ValueData  ELSE 'Ключ - для шифрування - Товариство з обмеженою в_дпов_дальн_стю АЛАН.ZS2' END AS UserKey
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


     -- определяется <Налоговый документ> и его параметры
     SELECT COALESCE (tmpMovement.MovementId_Tax, 0)                  AS MovementId_Tax
          , Movement_Tax.StatusId                                     AS StatusId_Tax
          , MovementLinkObject_DocumentTaxKind.ObjectId               AS DocumentTaxKindId
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE)   AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)          AS VATPercent
          , COALESCE (MovementLinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyPartnerId
          , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, MovementLinkObject_To.ObjectId, 0) AS GoodsPropertyId
          , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)       AS GoodsPropertyId_basis
          -- , ObjectLink_Juridical_GoodsProperty.ChildObjectId         AS GoodsPropertyId
          -- , ObjectLink_JuridicalBasis_GoodsProperty.ChildObjectId    AS GoodsPropertyId_basis

          , CASE --WHEN (CURRENT_DATE >= '01.03.2021'  /*OR vbUserId = 5*/) AND COALESCE (MovementString_InvNumberRegistered.ValueData, '') = ''
                   --   THEN '01.03.2021'
                 WHEN MovementDate_DateRegistered.ValueData > Movement_Tax.OperDate
                      THEN MovementDate_DateRegistered.ValueData
                 WHEN COALESCE (MovementString_InvNumberRegistered.ValueData, '') = ''
                      THEN '01.10.2024'
                 ELSE Movement_Tax.OperDate
            END AS OperDate_begin

          , CASE WHEN MovementString_InvNumberRegistered.ValueData <> ''
                      THEN COALESCE (MovementDate_DateRegistered.ValueData, Movement_Tax.OperDate)
                 ELSE CURRENT_DATE
            END AS OperDate_rus
            
          , Movement_Tax.OperDate AS OperDate_Tax_Tax
          
          , COALESCE (ObjectBoolean_isLongUKTZED.ValueData, TRUE)    AS isLongUKTZED
          
          , COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0) AS InfoMoneyId -- уп.статья из договора


          , ObjectString_Goods.ValueData        :: TVarChar AS Goods_DocumentTaxKind
          , ObjectString_Measure.ValueData      :: TVarChar AS Measure_DocumentTaxKind
          , ObjectString_MeasureCode.ValueData  :: TVarChar AS MeasureCode_DocumentTaxKind
          , ObjectFloat_Price.ValueData         :: TFloat   AS Price_DocumentTaxKind
       
            INTO vbMovementId_Tax, vbStatusId_Tax, vbDocumentTaxKindId, vbPriceWithVAT, vbVATPercent, vbCurrencyPartnerId, vbGoodsPropertyId, vbGoodsPropertyId_basis
               , vbOperDate_begin, vbOperDate_rus, vbOperDate_Tax_Tax, vbIsLongUKTZED
               , vbInfoMoneyId
               
               , vbGoods_DocumentTaxKind
               , vbMeasure_DocumentTaxKind
               , vbMeasureCode_DocumentTaxKind
               , vbPrice_DocumentTaxKind
     FROM (SELECT CASE WHEN Movement.DescId = zc_Movement_Tax()
                            THEN inMovementId
                       ELSE MovementLinkMovement_Master.MovementChildId
                  END AS MovementId_Tax
           FROM Movement
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                               ON MovementLinkMovement_Master.MovementId = Movement.Id
                                              AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
           WHERE Movement.Id = inMovementId
          ) AS tmpMovement
          LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = tmpMovement.MovementId_Tax

          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                         ON MovementLinkMovement_Master.MovementChildId = tmpMovement.MovementId_Tax
                                        AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                       ON MovementLinkObject_CurrencyPartner.MovementId = MovementLinkMovement_Master.MovementId
                                      AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()

          LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                   ON MovementString_InvNumberRegistered.MovementId = tmpMovement.MovementId_Tax
                                  AND MovementString_InvNumberRegistered.DescId = zc_MovementString_InvNumberRegistered()
          LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                 ON MovementDate_DateRegistered.MovementId = tmpMovement.MovementId_Tax
                                AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                       ON MovementLinkObject_DocumentTaxKind.MovementId = tmpMovement.MovementId_Tax
                                      AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = tmpMovement.MovementId_Tax
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = tmpMovement.MovementId_Tax
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = tmpMovement.MovementId_Tax
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                               ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                              AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = tmpMovement.MovementId_Tax
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_isLongUKTZED
                                  ON ObjectBoolean_isLongUKTZED.ObjectId = MovementLinkObject_To.ObjectId
                                 AND ObjectBoolean_isLongUKTZED.DescId = zc_ObjectBoolean_Juridical_isLongUKTZED()

          /*LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
          LEFT JOIN ObjectLink AS ObjectLink_JuridicalBasis_GoodsProperty
                               ON ObjectLink_JuridicalBasis_GoodsProperty.ObjectId = zc_Juridical_Basis()
                              AND ObjectLink_JuridicalBasis_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                              -- AND ObjectLink_Juridical_GoodsProperty.ChildObjectId IS NULL*/
                              
        -- свойства для DocumentTaxKind
        LEFT JOIN ObjectString AS ObjectString_Code
                               ON ObjectString_Code.ObjectId = MovementLinkObject_DocumentTaxKind.ObjectId
                              AND ObjectString_Code.DescId = zc_objectString_DocumentTaxKind_Code()
        LEFT JOIN ObjectString AS ObjectString_Goods
                               ON ObjectString_Goods.ObjectId = MovementLinkObject_DocumentTaxKind.ObjectId
                              AND ObjectString_Goods.DescId = zc_objectString_DocumentTaxKind_Goods()
        LEFT JOIN ObjectString AS ObjectString_Measure
                               ON ObjectString_Measure.ObjectId = MovementLinkObject_DocumentTaxKind.ObjectId
                              AND ObjectString_Measure.DescId = zc_objectString_DocumentTaxKind_Measure()
        LEFT JOIN ObjectString AS ObjectString_MeasureCode
                               ON ObjectString_MeasureCode.ObjectId = MovementLinkObject_DocumentTaxKind.ObjectId
                              AND ObjectString_MeasureCode.DescId = zc_objectString_DocumentTaxKind_MeasureCode()
        LEFT JOIN ObjectFloat AS ObjectFloat_Price
                              ON ObjectFloat_Price.ObjectId = MovementLinkObject_DocumentTaxKind.ObjectId
                             AND ObjectFloat_Price.DescId = zc_objectFloat_DocumentTaxKind_Price()
     ;

-- IF vbUserId = 5 THEN RAISE EXCEPTION 'Ошибка.<%>', vbOperDate_begin; end if;

     -- очень важная проверка
     IF COALESCE (vbMovementId_Tax, 0) = 0 OR (COALESCE (vbStatusId_Tax, 0) <> zc_Enum_Status_Complete() AND vbDocumentTaxKindId <> zc_Enum_DocumentTaxKind_Prepay())
     THEN
         IF COALESCE (vbMovementId_Tax, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> не создан.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax());
         END IF;
         IF vbStatusId_Tax = zc_Enum_Status_Erased()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax()), (SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_Tax AND DescId = zc_MovementString_InvNumberPartner()), (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementId_Tax);
         END IF;
         IF vbStatusId_Tax = zc_Enum_Status_UnComplete()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax()), (SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_Tax AND DescId = zc_MovementString_InvNumberPartner()), (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementId_Tax);
         END IF;
         -- это уже странная ошибка
         RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax());
     END IF;


     -- определяется <Продажа покупателю> или <Перевод долга (расход)>
     SELECT COALESCE(CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut())
                               THEN inMovementId
                          ELSE MovementLinkMovement_Master.MovementId
                     END, 0)
            INTO vbMovementId_Sale
     FROM Movement
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                         ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                        AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
     WHERE Movement.Id = inMovementId;


     -- Данные по заголовку налоговой
     OPEN Cursor1 FOR
       -- Сотрудник (бухгалтер) подписант
       WITH tmpBranch_PersonalBookkeeper AS (SELECT Object_PersonalBookkeeper_View.MemberId
                                                  , MAX (ObjectString_PersonalBookkeeper.ValueData) AS PersonalBookkeeperName
                                             FROM Object AS Object_Branch
                                                  -- Сотрудник (бухгалтер)
                                                  LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalBookkeeper
                                                                       ON ObjectLink_Branch_PersonalBookkeeper.ObjectId = Object_Branch.Id
                                                                      AND ObjectLink_Branch_PersonalBookkeeper.DescId = zc_ObjectLink_Branch_PersonalBookkeeper()
                                                  LEFT JOIN Object_Personal_View AS Object_PersonalBookkeeper_View ON Object_PersonalBookkeeper_View.PersonalId = ObjectLink_Branch_PersonalBookkeeper.ChildObjectId                     
                                                  -- Сотрудник (бухгалтер) подписант
                                                  INNER JOIN ObjectString AS ObjectString_PersonalBookkeeper
                                                                          ON ObjectString_PersonalBookkeeper.ObjectId  = Object_Branch.Id
                                                                         AND ObjectString_PersonalBookkeeper.DescId    = zc_objectString_Branch_PersonalBookkeeper()
                                                                         AND ObjectString_PersonalBookkeeper.ValueData <> ''
                                             WHERE Object_Branch.DescId   = zc_Object_Branch()
                                               AND Object_Branch.isErased = FALSE
                                             GROUP BY Object_PersonalBookkeeper_View.MemberId
                                            )
       -- Результат
       SELECT
             Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , vbOperDate_begin                           AS OperDate_begin -- поле для Медка
           , CASE WHEN Movement.OperDate < '01.01.2015' THEN 'J1201006'
                  WHEN vbOperDate_begin  < '01.04.2016' THEN 'J1201007'
                  WHEN Movement.OperDate < '01.03.2017' THEN 'J1201008'
                  WHEN vbOperDate_begin  < '01.12.2018' THEN 'J1201009'
                  WHEN vbOperDate_begin  < '01.03.2021' THEN 'J1201010'
                  WHEN vbOperDate_begin  < '16.03.2021' THEN 'J1201011'
                  WHEN vbOperDate_begin  < '01.10.2024' THEN 'J1201012'
                  ELSE 'J1201016'
             END ::TVarChar AS CHARCODE


             -- Сотрудник подписант
           , CASE -- контрагент
                  WHEN Object_PersonalSigning_partner.PersonalName <> ''
                       THEN COALESCE (tmpBranch_PersonalBookkeeper_partner.PersonalBookkeeperName, Object_PersonalSigning_partner.PersonalName)

                  -- договор - замена
                  WHEN tmpBranch_PersonalBookkeeper.PersonalBookkeeperName <> ''
                       THEN tmpBranch_PersonalBookkeeper.PersonalBookkeeperName
                  -- договор
                  WHEN Object_PersonalSigning.PersonalName <> ''
                       THEN zfConvert_FIO (Object_PersonalSigning.PersonalName, 1, FALSE)
                  -- филиал - Сотрудник (бухгалтер) подписант + Сотрудник (бухгалтер)
                  ELSE CASE WHEN COALESCE (ObjectString_PersonalBookkeeper.ValueData, Object_PersonalBookkeeper_View.PersonalName,'') <> ''
                            THEN COALESCE (ObjectString_PersonalBookkeeper.ValueData, zfConvert_FIO ( Object_PersonalBookkeeper_View.PersonalName, 1, FALSE),'')
                            ELSE 'Рудик Н.В.'
                       END

             END                            :: TVarChar AS N10

             -- Сотрудник подписант
           , CASE -- контрагент
                  WHEN Object_PersonalSigning_partner.PersonalName <> ''
                       THEN UPPER (COALESCE (tmpBranch_PersonalBookkeeper_partner.PersonalBookkeeperName, Object_PersonalSigning_partner.PersonalName))

                  -- договор - замена
                  WHEN tmpBranch_PersonalBookkeeper.PersonalBookkeeperName <> ''
                       THEN UPPER (tmpBranch_PersonalBookkeeper.PersonalBookkeeperName)
                  -- договор
                  WHEN Object_PersonalSigning.PersonalName <> ''
                       THEN UPPER (zfConvert_FIO (Object_PersonalSigning.PersonalName, 1, TRUE))
                  -- филиал - Сотрудник (бухгалтер) подписант + Сотрудник (бухгалтер)
                  ELSE CASE WHEN COALESCE (ObjectString_PersonalBookkeeper.ValueData, Object_PersonalBookkeeper_View.PersonalName,'') <> ''
                            THEN UPPER (COALESCE (ObjectString_PersonalBookkeeper.ValueData, zfConvert_FIO (Object_PersonalBookkeeper_View.PersonalName, 1, TRUE),'') )
                            ELSE UPPER ('Н. В. Рудик' )
                       END
             END                            :: TVarChar AS N10_ifin

           , 'оплата з поточного рахунка'::TVarChar     AS N9
/*
           , CASE WHEN OH_JuridicalDetails_To.INN = vbNotNDSPayer_INN
                  THEN ''
             ELSE CAST (REPEAT (' ', 7 - LENGTH (MovementString_InvNumberPartner.ValueData)) || MovementString_InvNumberPartner.ValueData AS TVarChar)
             END                                        AS InvNumberPartner
*/
           ,  CAST (REPEAT (' ', 7 - LENGTH (MovementString_InvNumberPartner.ValueData)) || MovementString_InvNumberPartner.ValueData AS TVarChar) AS InvNumberPartner
           ,  CAST (REPEAT ('0', 7 - LENGTH (MovementString_InvNumberPartner.ValueData)) || MovementString_InvNumberPartner.ValueData AS TVarChar) AS InvNumberPartner_ifin

           , vbPriceWithVAT                             AS PriceWithVAT

/*         -- в делфи прописано все для параметра VATPercent (901,902) 
           , CASE WHEN COALESCE (ObjectBoolean_Vat.ValueData, False) = True
                       THEN 902
                  WHEN (vbCurrencyPartnerId <> zc_Enum_Currency_Basis() AND COALESCE (ObjectBoolean_Vat.ValueData, False) = False)
                       THEN 901
                  ElSE 20
             END AS CodeStavka
             */

           , CASE WHEN COALESCE (ObjectBoolean_Vat.ValueData, False) = True
                       THEN 902
                  WHEN (vbCurrencyPartnerId <> zc_Enum_Currency_Basis() AND COALESCE (ObjectBoolean_Vat.ValueData, False) = False)
                       THEN 901
                  ElSE vbVATPercent
             END AS VATPercent

           , CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() and COALESCE (ObjectBoolean_Vat.ValueData, False) = False THEN MovementFloat_TotalSummMVAT.ValueData ELSE 0 END AS TotalSummMVAT
          --, CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() OR COALESCE (ObjectBoolean_Vat.ValueData, False) = True THEN MovementFloat_TotalSummPVAT.ValueData ELSE 0 END AS TotalSummPVAT
           , (MovementFloat_TotalSummPVAT.ValueData
            - CASE WHEN inMovementId = 25962252 THEN 0.01 ELSE 0 END -- № 5647 от 17.08.2023 - Військова частина Т0920 м. Дніпро вул. Стартова буд.15
             ) ::TFloat AS TotalSummPVAT
           , CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() and COALESCE (ObjectBoolean_Vat.ValueData, False) = False 
                       THEN COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0)
                          - CASE WHEN inMovementId = 25962252 THEN 0.01 ELSE 0 END -- № 5647 от 17.08.2023 - Військова частина Т0920 м. Дніпро вул. Стартова буд.15
                       ELSE 0
            END :: TFloat AS SummVAT
             
           , (MovementFloat_TotalSumm.ValueData
            - CASE WHEN inMovementId = 25962252 THEN 0.01 ELSE 0 END -- № 5647 от 17.08.2023 - Військова частина Т0920 м. Дніпро вул. Стартова буд.15
             ) :: TFloat AS TotalSumm

           , CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() and COALESCE (ObjectBoolean_Vat.ValueData, False) = False THEN 0 ELSE MovementFloat_TotalSummMVAT.ValueData END AS TotalSummMVAT_11
           , CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() and COALESCE (ObjectBoolean_Vat.ValueData, False) = False THEN 0 ELSE MovementFloat_TotalSummPVAT.ValueData END AS TotalSummPVAT_11
           , CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() and COALESCE (ObjectBoolean_Vat.ValueData, False) = False THEN 0 ELSE COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) END AS SummVAT_11

           , Object_From.ValueData             		AS FromName
           , Object_To.ValueData               		AS ToName

           , View_Contract.InvNumber         		AS ContractName
           , ObjectDate_Signing.ValueData               AS ContractSigningDate
           , View_Contract.ContractKindName             AS ContractKind

           , ObjectString_ToAddress.ValueData           AS PartnerAddress_To

           --, OH_JuridicalDetails_To.FullName            AS JuridicalName_To
           , CASE WHEN Object_To.Id = 9840136 AND 1=1 -- AND vbUserId = 5
                       -- Укрзалізниця АТ
                       THEN COALESCE (OH_JuridicalDetails_To.Name, '')

                  -- Название юр.лица для филиала
                  WHEN ObjectString_BranchJur.ValueData <> ''
                       THEN ObjectString_BranchJur.ValueData

                  WHEN COALESCE (MovementString_ToINN.ValueData, OH_JuridicalDetails_To.INN) = vbNotNDSPayer_INN
                    OR vbCalcNDSPayer_INN <> ''
                       THEN 'Неплатник'
                  ELSE OH_JuridicalDetails_To.FullName
             END :: TVarChar AS JuridicalName_To

           , CASE WHEN Object_To.Id = 9840136 AND 1=1 -- AND vbUserId = 5
                       -- Укрзалізниця АТ - Условное обозначение
                       THEN ', ' || TRIM (TRIM (LOWER (SPLIT_PART (ObjectString_ShortName.ValueData, 'підрозділ', 1)))
                          || ' ' || TRIM (SPLIT_PART (SPLIT_PART (ObjectString_ShortName.ValueData, 'філії', 1), 'Структурний', 2)))
                       
                  ELSE ''
             END :: TVarChar AS JuridicalName_To_add

           , CASE WHEN COALESCE (MovementString_ToINN.ValueData, OH_JuridicalDetails_To.INN) = vbNotNDSPayer_INN
                    OR vbCalcNDSPayer_INN <> ''
                  THEN ''
                  ELSE OH_JuridicalDetails_To.JuridicalAddress
             END AS JuridicalAddress_To

--           , OH_JuridicalDetails_To.JuridicalAddress    AS JuridicalAddress_To
           , CASE WHEN vbOperDate_begin >= '01.12.2018' 
                   AND COALESCE (MovementString_ToINN.ValueData, OH_JuridicalDetails_To.INN) IN ('100000000000', '300000000000')
                  THEN ''
                  ELSE COALESCE (ObjectString_Retail_OKPO.ValueData, OH_JuridicalDetails_To.OKPO)
             END :: TVarChar AS OKPO_To
           , CASE WHEN COALESCE (MovementString_ToINN.ValueData, OH_JuridicalDetails_To.INN) IN ('100000000000', '300000000000')
                  THEN ''
                  ELSE (REPEAT ('0', 10 - LENGTH (OH_JuridicalDetails_To.OKPO)) ||  OH_JuridicalDetails_To.OKPO)
             END :: TVarChar AS OKPO_To_ifin

           , CASE WHEN vbCalcNDSPayer_INN <> '' THEN vbCalcNDSPayer_INN ELSE COALESCE (MovementString_ToINN.ValueData, OH_JuridicalDetails_To.INN) END AS INN_To
           , OH_JuridicalDetails_To.NumberVAT           AS NumberVAT_To
           , OH_JuridicalDetails_To.AccounterName       AS AccounterName_To
           , OH_JuridicalDetails_To.BankAccount         AS BankAccount_To
           , OH_JuridicalDetails_To.BankName            AS BankName_To
           , OH_JuridicalDetails_To.MFO                 AS BankMFO_To
--           , OH_JuridicalDetails_To.Phone               AS Phone_To
             
           , CASE WHEN Object_To.Id = 9840136 AND ObjectString_RoomNumber.ValueData <> '' -- AND vbUserId = 5
                       -- Укрзалізниця АТ - № Склада или Номер филиала или кв.:
                       THEN ObjectString_RoomNumber.ValueData 

                  -- Номер филиала
                  WHEN ObjectString_BranchCode.ValueData <> ''
                       THEN ObjectString_BranchCode.ValueData

                  ELSE OH_JuridicalDetails_To.InvNumberBranch

             END :: TVarChar AS InvNumberBranch_To

           , CASE WHEN COALESCE (MovementString_ToINN.ValueData, OH_JuridicalDetails_To.INN) = vbNotNDSPayer_INN
                    OR vbCalcNDSPayer_INN <> ''
                  THEN ''
             ELSE OH_JuridicalDetails_To.Phone END      AS Phone_To

           --с 01,03,2021 новый параметр Код - если номер платника податку заполнен  в ячейку ставим 1, иначе пусто
           , CASE WHEN Object_To.ValueData LIKE '%ФОП%'
                   AND LENGTH(trim (COALESCE (ObjectString_Retail_OKPO.ValueData, OH_JuridicalDetails_To.OKPO,''))) = 10
                   AND COALESCE (MovementString_ToINN.ValueData, OH_JuridicalDetails_To.INN) <> '100000000000'
                  THEN '2'
                  WHEN COALESCE (MovementString_ToINN.ValueData, OH_JuridicalDetails_To.INN) IN ('100000000000', '300000000000','')
                    OR COALESCE (ObjectString_Retail_OKPO.ValueData, OH_JuridicalDetails_To.OKPO,'') = ''
                  THEN ''
                  ELSE '1'
             END :: TVarChar AS Code_To


           /*, ObjectString_BuyerGLNCode.ValueData        AS BuyerGLNCode
           , ObjectString_SupplierGLNCode.ValueData     AS SupplierGLNCode*/
           , zfCalc_GLNCodeJuridical (inGLNCode                  := 'ok'
                                    , inGLNCodeJuridical_partner := ObjectString_Partner_GLNCodeJuridical.ValueData
                                    , inGLNCodeJuridical         := ObjectString_Juridical_GLNCode.ValueData
                                     ) AS BuyerGLNCode

           , CASE WHEN OH_JuridicalDetails_To.JuridicalId = 15158 -- МЕТРО Кеш енд Кері Україна ТОВ
                       THEN '' -- если Метро, тогда наш = "пусто"
                  ELSE zfCalc_GLNCodeCorporate (inGLNCode                  := 'ok'
                                              , inGLNCodeCorporate_partner := ObjectString_Partner_GLNCodeCorporate.ValueData
                                              , inGLNCodeCorporate_retail  := ObjectString_Retail_GLNCodeCorporate.ValueData
                                              , inGLNCodeCorporate_main    := ObjectString_JuridicalFrom_GLNCode.ValueData
                                               )
             END :: TVarChar AS SupplierGLNCode

           , OH_JuridicalDetails_From.FullName          AS JuridicalName_From
           , OH_JuridicalDetails_From.JuridicalAddress  AS JuridicalAddress_From
           , OH_JuridicalDetails_From.OKPO              AS OKPO_From
           , CASE WHEN OH_JuridicalDetails_From.INN IN ('100000000000', '300000000000')
                  THEN ''
                  ELSE (REPEAT ('0', 10 - LENGTH (OH_JuridicalDetails_From.OKPO)) ||  OH_JuridicalDetails_From.OKPO) 
             END :: TVarChar AS OKPO_From_ifin

           , OH_JuridicalDetails_From.INN               AS INN_From
           , OH_JuridicalDetails_From.NumberVAT         AS NumberVAT_From

           , CASE -- контрагент
                  WHEN Object_PersonalSigning_partner.PersonalName <> ''
                       THEN COALESCE (tmpBranch_PersonalBookkeeper_partner.PersonalBookkeeperName, Object_PersonalSigning_partner.PersonalName)

                  -- договор - замена
                  WHEN tmpBranch_PersonalBookkeeper.PersonalBookkeeperName <> ''
                       THEN tmpBranch_PersonalBookkeeper.PersonalBookkeeperName
                  -- договор
                  WHEN Object_PersonalSigning.PersonalName <> ''
                       THEN zfConvert_FIO (Object_PersonalSigning.PersonalName, 1, FALSE)

                  -- филиал - Сотрудник (бухгалтер) подписант + Сотрудник (бухгалтер)
                  ELSE CASE WHEN COALESCE (ObjectString_PersonalBookkeeper.ValueData, Object_PersonalBookkeeper_View.PersonalName,'') <> ''
                            THEN COALESCE (ObjectString_PersonalBookkeeper.ValueData, zfConvert_FIO (Object_PersonalBookkeeper_View.PersonalName, 1, FALSE),'')
                            ELSE 'Рудик Н.В.'
                       END
              END                           :: TVarChar AS AccounterName_From
     
             -- Сотрудник подписант
           , CASE -- контрагент
                  WHEN Object_PersonalSigning_partner.PersonalName <> ''
                       THEN PersonalSigning_INN_partner.ValueData

                  -- договор - замена
                  WHEN tmpBranch_PersonalBookkeeper.PersonalBookkeeperName <> ''
                       THEN PersonalSigning_INN_two.ValueData

                  -- договор
                  WHEN Object_PersonalSigning.PersonalName <> ''
                       THEN PersonalSigning_INN.ValueData

                  -- филиал - Сотрудник (бухгалтер) подписант + Сотрудник (бухгалтер)
                  ELSE CASE WHEN COALESCE (ObjectString_PersonalBookkeeper.ValueData, Object_PersonalBookkeeper_View.PersonalName,'') <> ''
                            THEN PersonalBookkeeper_INN.ValueData
                            ELSE '2649713447'
                       END
             END                            :: TVarChar AS AccounterINN_From

           , OH_JuridicalDetails_From.BankAccount       AS BankAccount_From
           , OH_JuridicalDetails_From.BankName          AS BankName_From
           , OH_JuridicalDetails_From.MFO               AS BankMFO_From
           , OH_JuridicalDetails_From.Phone             AS Phone_From
           , OH_JuridicalDetails_From.InvNumberBranch   AS InvNumberBranch_From

           --с 01,03,2021 новый параметр Код - если номер платника податку заполнен  в ячейку ставим 1, иначе пусто
           , CASE WHEN COALESCE (OH_JuridicalDetails_From.OKPO,'') <> '' THEN '1' ELSE '' END ::TVarChar AS Code_From

           , MovementString_InvNumberPartnerEDI.ValueData  AS InvNumberPartnerEDI
           , COALESCE (MovementDate_COMDOC.ValueData, COALESCE (Movement_EDI.OperDate, MovementDate_OperDatePartnerEDI.ValueData))    AS OperDatePartnerEDI_tax
           , COALESCE (MovementDate_COMDOC.ValueData, COALESCE (Movement_EDI.OperDate, MovementDate_OperDatePartnerEDI.ValueData))    AS OperDatePartnerEDI

           , CASE WHEN inisClientCopy = TRUE
                  THEN 'X' ELSE '' END                  AS CopyForClient
           , CASE WHEN inisClientCopy = TRUE
                  THEN '' ELSE 'X' END                  AS CopyForUs
           , CASE WHEN (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0)) > 10000
                  THEN 'X' ELSE '' END                  AS ERPN

             -- Не підлягає наданню отримувачу (покупцю)
           , CASE WHEN COALESCE (MovementString_ToINN.ValueData, OH_JuridicalDetails_To.INN) = vbNotNDSPayer_INN
                    OR vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                    OR vbCalcNDSPayer_INN <> ''
                    OR (vbOperDate_begin >= '01.12.2018' AND COALESCE (ObjectString_Retail_OKPO.ValueData, OH_JuridicalDetails_To.OKPO) = '100000000000')
                   THEN 'X' 
                   ELSE '' END                  AS NotNDSPayer

           , CASE WHEN COALESCE (MovementString_ToINN.ValueData, OH_JuridicalDetails_To.INN) = vbNotNDSPayer_INN
                    OR vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                    OR vbCalcNDSPayer_INN <> ''
                    OR (vbOperDate_begin >= '01.12.2018' AND COALESCE (ObjectString_Retail_OKPO.ValueData, OH_JuridicalDetails_To.OKPO) = '100000000000')
                  THEN TRUE ELSE FALSE END :: Boolean   AS isNotNDSPayer

             -- 1 - (зазначається відповідний тип причини)
           , CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                       THEN '0'
                  WHEN COALESCE (MovementString_ToINN.ValueData, OH_JuridicalDetails_To.INN) = vbNotNDSPayer_INN
                    OR vbCalcNDSPayer_INN <> ''
                    OR (vbOperDate_begin >= '01.12.2018' AND COALESCE (ObjectString_Retail_OKPO.ValueData, OH_JuridicalDetails_To.OKPO) = '100000000000')
                       THEN '0'
              END AS NotNDSPayerC1
             -- 2 - (зазначається відповідний тип причини)
           , CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                       THEN '7'
                  WHEN COALESCE (MovementString_ToINN.ValueData, OH_JuridicalDetails_To.INN) = vbNotNDSPayer_INN
                    OR vbCalcNDSPayer_INN <> ''
                    OR (vbOperDate_begin >= '01.12.2018' AND COALESCE (ObjectString_Retail_OKPO.ValueData, OH_JuridicalDetails_To.OKPO) = '100000000000')
                       THEN '2'
             END AS NotNDSPayerC2

           , CAST (REPEAT (' ', 4 - LENGTH (MovementString_InvNumberBranch.ValueData)) || MovementString_InvNumberBranch.ValueData AS TVarChar) AS InvNumberBranch

           , COALESCE(MovementLinkMovement_Sale.MovementChildId, 0) AS EDIId

           , COALESCE(MovementFloat_Amount.ValueData, 0) AS SendDeclarAmount

           , CASE WHEN vbDocumentTaxKindId NOT IN (zc_Enum_DocumentTaxKind_Tax(), zc_Enum_DocumentTaxKind_Prepay()) AND vbOperDate_begin < '01.12.2018' THEN 'X' 
                  WHEN vbDocumentTaxKindId NOT IN (zc_Enum_DocumentTaxKind_Tax(), zc_Enum_DocumentTaxKind_Prepay(), zc_Enum_DocumentTaxKind_ChangeErr()) AND vbOperDate_begin >= '01.12.2018' THEN '4'
                  ELSE '' 
             END AS TaxKind -- для сводной НН

           , COALESCE (ObjectBoolean_Vat.ValueData, False) AS  isVat

           , vbUserSign AS UserSign
           , vbUserSeal AS UserSeal
           , vbUserKey  AS UserKey

           , 'O=ТОВАРИСТВО З ОБМЕЖЕНОЮ ВІДПОВІДАЛЬНІСТЮ "Е-КОМ";PostalCode=01042;CN=ТОВАРИСТВО З ОБМЕЖЕНОЮ ВІДПОВІДАЛЬНІСТЮ "Е-КОМ";Serial=34241719;C=UA;L=місто КИЇВ;StreetAddress=провулок Новопечерський, буд. 19/3, корпус 1, к. 6'
              :: TBlob AS NameExite
           , 'O=Державна фіскальна служба України;CN=Державна фіскальна служба України.  ОТРИМАНО;Serial=2122385;C=UA;L=Київ'
              :: TBlob AS NameFiscal

       FROM Movement
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Sale
                                           ON MovementLinkMovement_Sale.MovementId = inMovementId
                                          AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Sale()

            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                    ON MovementFloat_Amount.MovementId = MovementLinkMovement_Sale.MovementChildId
                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()

            LEFT JOIN Movement AS Movement_EDI ON Movement_EDI.Id =  MovementLinkMovement_Sale.MovementChildId

            LEFT JOIN MovementDate AS MovementDate_COMDOC
                                   ON MovementDate_COMDOC.MovementId =  MovementLinkMovement_Sale.MovementChildId
                                  AND MovementDate_COMDOC.DescId = zc_MovementDate_COMDOC()


            LEFT JOIN MovementDate AS MovementDate_OperDatePartnerEDI
                                   ON MovementDate_OperDatePartnerEDI.MovementId = MovementLinkMovement_Sale.MovementChildId
                                  AND MovementDate_OperDatePartnerEDI.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementString AS MovementString_InvNumberPartnerEDI
                                     ON MovementString_InvNumberPartnerEDI.MovementId = MovementLinkMovement_Sale.MovementChildId
                                    AND MovementString_InvNumberPartnerEDI.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_InvNumberBranch
                                     ON MovementString_InvNumberBranch.MovementId = Movement.Id
                                    AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_ToINN
                                     ON MovementString_ToINN.MovementId = Movement.Id
                                    AND MovementString_ToINN.DescId = zc_MovementString_ToINN()
                                    AND MovementString_ToINN.ValueData  <> ''

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Branch
                                         ON MovementLinkObject_Branch.MovementId = Movement.Id
                                        AND MovementLinkObject_Branch.DescId = zc_MovementLinkObject_Branch()
            -- Сотрудник (бухгалтер) - филиал
            LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalBookkeeper
                                 ON ObjectLink_Branch_PersonalBookkeeper.ObjectId = MovementLinkObject_Branch.ObjectId
                                AND ObjectLink_Branch_PersonalBookkeeper.DescId = zc_ObjectLink_Branch_PersonalBookkeeper()
            LEFT JOIN Object_Personal_View AS Object_PersonalBookkeeper_View ON Object_PersonalBookkeeper_View.PersonalId = ObjectLink_Branch_PersonalBookkeeper.ChildObjectId
            -- Сотрудник (бухгалтер) подписант - филиал
            LEFT JOIN ObjectString AS ObjectString_PersonalBookkeeper
                                   ON ObjectString_PersonalBookkeeper.ObjectId = MovementLinkObject_Branch.ObjectId
                                  AND ObjectString_PersonalBookkeeper.DescId = zc_objectString_Branch_PersonalBookkeeper()

            LEFT JOIN ObjectString AS PersonalBookkeeper_INN
                                   ON PersonalBookkeeper_INN.ObjectId = Object_PersonalBookkeeper_View.MemberId
                                  AND PersonalBookkeeper_INN.DescId = zc_ObjectString_Member_INN()


            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            -- Сотрудник подписант - контрагент
            LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalSigning
                                 ON ObjectLink_Partner_PersonalSigning.ObjectId = MovementLinkObject_Partner.ObjectId
                                AND ObjectLink_Partner_PersonalSigning.DescId   = zc_ObjectLink_Partner_PersonalSigning()
            LEFT JOIN Object_Personal_View AS Object_PersonalSigning_partner ON Object_PersonalSigning_partner.PersonalId = ObjectLink_Partner_PersonalSigning.ChildObjectId   
            -- Сотрудник подписант - замена
            LEFT JOIN tmpBranch_PersonalBookkeeper AS tmpBranch_PersonalBookkeeper_partner ON tmpBranch_PersonalBookkeeper_partner.MemberId = Object_PersonalSigning_partner.MemberId
            LEFT JOIN ObjectString AS PersonalSigning_INN_partner
                                   ON PersonalSigning_INN_partner.ObjectId = COALESCE (tmpBranch_PersonalBookkeeper_partner.MemberId, Object_PersonalSigning_partner.MemberId)
                                  AND PersonalSigning_INN_partner.DescId   = zc_ObjectString_Member_INN()

            LEFT JOIN ObjectString AS ObjectString_ToAddress
                                   ON ObjectString_ToAddress.ObjectId = MovementLinkObject_Partner.ObjectId
                                  AND ObjectString_ToAddress.DescId = zc_ObjectString_Partner_Address()
            -- № Склада или Номер филиала или кв.:
            LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                   ON ObjectString_RoomNumber.ObjectId = MovementLinkObject_Partner.ObjectId
                                  AND ObjectString_RoomNumber.DescId = zc_ObjectString_Partner_RoomNumber()
            -- Условное обозначение
            LEFT JOIN ObjectString AS ObjectString_ShortName
                                   ON ObjectString_ShortName.ObjectId = MovementLinkObject_Partner.ObjectId
                                  AND ObjectString_ShortName.DescId = zc_ObjectString_Partner_ShortName()
            -- Номер филиала
            LEFT JOIN ObjectString AS ObjectString_BranchCode
                                   ON ObjectString_BranchCode.ObjectId = MovementLinkObject_Partner.ObjectId
                                  AND ObjectString_BranchCode.DescId = zc_ObjectString_Partner_BranchCode()
            -- Название юр.лица для филиала
            LEFT JOIN ObjectString AS ObjectString_BranchJur
                                   ON ObjectString_BranchJur.ObjectId = MovementLinkObject_Partner.ObjectId
                                  AND ObjectString_BranchJur.DescId = zc_ObjectString_Partner_BranchJur()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                ON OH_JuridicalDetails_To.JuridicalId = Object_To.Id
                                                               AND Movement.OperDate >= OH_JuridicalDetails_To.StartDate AND Movement.OperDate < OH_JuridicalDetails_To.EndDate
            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = Object_From.Id
                                                               AND Movement.OperDate >= OH_JuridicalDetails_From.StartDate AND Movement.OperDate < OH_JuridicalDetails_From.EndDate
            /*LEFT JOIN ObjectString AS ObjectString_BuyerGLNCode
                                   ON ObjectString_BuyerGLNCode.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                  AND ObjectString_BuyerGLNCode.DescId = zc_ObjectString_Juridical_GLNCode()
            LEFT JOIN ObjectString AS ObjectString_SupplierGLNCode
                                   ON ObjectString_SupplierGLNCode.ObjectId = OH_JuridicalDetails_From.JuridicalId
                                  AND ObjectString_SupplierGLNCode.DescId = zc_ObjectString_Juridical_GLNCode()*/

            LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeJuridical
                                   ON ObjectString_Partner_GLNCodeJuridical.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_Partner_GLNCodeJuridical.DescId = zc_ObjectString_Partner_GLNCodeJuridical()
            LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeCorporate
                                   ON ObjectString_Partner_GLNCodeCorporate.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_Partner_GLNCodeCorporate.DescId = zc_ObjectString_Partner_GLNCodeCorporate()

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode
                                   ON ObjectString_Juridical_GLNCode.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                  AND ObjectString_Juridical_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()
            LEFT JOIN ObjectString AS ObjectString_Retail_GLNCodeCorporate
                                   ON ObjectString_Retail_GLNCodeCorporate.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                  AND ObjectString_Retail_GLNCodeCorporate.DescId = zc_ObjectString_Retail_GLNCodeCorporate()

            LEFT JOIN ObjectString AS ObjectString_Retail_OKPO
                                   ON ObjectString_Retail_OKPO.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                  AND ObjectString_Retail_OKPO.DescId = zc_ObjectString_Retail_OKPO()

            LEFT JOIN ObjectString AS ObjectString_JuridicalFrom_GLNCode
                                   ON ObjectString_JuridicalFrom_GLNCode.ObjectId = OH_JuridicalDetails_From.JuridicalId
                                  AND ObjectString_JuridicalFrom_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = MovementLinkObject_Contract.ObjectId
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                AND View_Contract.InvNumber <> '-'

            -- Сотрудник подписант - договор
            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalSigning
                                 ON ObjectLink_Contract_PersonalSigning.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_PersonalSigning.DescId = zc_ObjectLink_Contract_PersonalSigning()
            LEFT JOIN Object_Personal_View AS Object_PersonalSigning ON Object_PersonalSigning.PersonalId = ObjectLink_Contract_PersonalSigning.ChildObjectId
            -- Сотрудник подписант - замена
            LEFT JOIN tmpBranch_PersonalBookkeeper ON tmpBranch_PersonalBookkeeper.MemberId = Object_PersonalSigning.MemberId
            LEFT JOIN ObjectString AS PersonalSigning_INN_two
                                   ON PersonalSigning_INN_two.ObjectId = tmpBranch_PersonalBookkeeper.MemberId
                                  AND PersonalSigning_INN_two.DescId   = zc_ObjectString_Member_INN()

            LEFT JOIN ObjectString AS PersonalSigning_INN
                                   ON PersonalSigning_INN.ObjectId = Object_PersonalSigning.MemberId
                                  AND PersonalSigning_INN.DescId = zc_ObjectString_Member_INN()
            -- ставка 0 таможня
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Vat
                                    ON ObjectBoolean_Vat.ObjectId = View_Contract.ContractId
                                   AND ObjectBoolean_Vat.DescId = zc_ObjectBoolean_Contract_Vat()
       WHERE Movement.Id =  vbMovementId_Tax
         AND (Movement.StatusId = zc_Enum_Status_Complete() OR vbDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay())
      ;
     RETURN NEXT Cursor1;


     -- Данные по строчной части налоговой
     OPEN Cursor2 FOR
     WITH tmpMI AS
       (SELECT MovementItem.Id                        AS Id
             , MovementItem.MovementId                AS MovementId
             , MovementItem.ObjectId                  AS GoodsId
             , MovementItem.Amount                    AS Amount
             , MIFloat_Price.ValueData                AS Price
             , MIFloat_CountForPrice.ValueData        AS CountForPrice
             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
             , ObjectLink_GoodsGroup.ChildObjectId    AS GoodsGroupId
             , COALESCE (MIBoolean_Goods_Name_new.ValueData, FALSE) ::Boolean AS isName_new
             , COALESCE (MIFloat_NPP.ValueData, 0)    AS NPP
        FROM MovementItem
             INNER JOIN MovementItemFloat AS MIFloat_Price
                                          ON MIFloat_Price.MovementItemId = MovementItem.Id
                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                         -- AND MIFloat_Price.ValueData <> 0
             LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                         ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                        AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
             LEFT JOIN MovementItemFloat AS MIFloat_NPP
                                         ON MIFloat_NPP.MovementItemId = MovementItem.Id
                                        AND MIFloat_NPP.DescId = zc_MIFloat_NPP()           
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                  ON ObjectLink_GoodsGroup.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN MovementItemBoolean AS MIBoolean_Goods_Name_new
                                           ON MIBoolean_Goods_Name_new.MovementItemId = MovementItem.Id
                                          AND MIBoolean_Goods_Name_new.DescId = zc_MIBoolean_Goods_Name_new()
        WHERE MovementItem.MovementId = vbMovementId_Tax
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased   = FALSE
          AND MovementItem.Amount     <> 0
       )
    , tmpGoods     AS (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)
      -- на дату
    , tmpUKTZED    AS (SELECT tmp.GoodsGroupId, lfGet_Object_GoodsGroup_CodeUKTZED_onDate (tmp.GoodsGroupId, vbOperDate_Tax_Tax) AS CodeUKTZED
                       FROM (SELECT DISTINCT tmpMI.GoodsGroupId FROM tmpMI) AS tmp
                      )
      -- на дату
    , tmpUKTZED_new AS (SELECT tmp.GoodsGroupId, lfGet_Object_GoodsGroup_CodeUKTZED_onDate (tmp.GoodsGroupId, CURRENT_DATE + INTERVAL '3 MONTH') AS CodeUKTZED
                        FROM (SELECT DISTINCT tmpMI.GoodsGroupId FROM tmpMI) AS tmp
                       )
      --
    , tmpTaxImport AS (SELECT tmp.GoodsGroupId, lfGet_Object_GoodsGroup_TaxImport (tmp.GoodsGroupId) AS TaxImport FROM (SELECT DISTINCT tmpMI.GoodsGroupId FROM tmpMI) AS tmp)
    , tmpDKPP      AS (SELECT tmp.GoodsGroupId, lfGet_Object_GoodsGroup_DKPP (tmp.GoodsGroupId) AS DKPP FROM (SELECT DISTINCT tmpMI.GoodsGroupId FROM tmpMI) AS tmp)
    , tmpTaxAction AS (SELECT tmp.GoodsGroupId, lfGet_Object_GoodsGroup_TaxAction (tmp.GoodsGroupId) AS TaxAction FROM (SELECT DISTINCT tmpMI.GoodsGroupId FROM tmpMI) AS tmp)
    , tmpObject_GoodsPropertyValue AS
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

             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                   ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             INNER JOIN tmpGoods ON tmpGoods.GoodsId = ObjectLink_GoodsPropertyValue_Goods.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )
     , tmpObject_GoodsPropertyValueGroup AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.Article
             , tmpObject_GoodsPropertyValue.ArticleGLN
             , tmpObject_GoodsPropertyValue.Name
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Article <> '' OR ArticleGLN <> '' OR Name <> '' GROUP BY GoodsId
             ) AS tmpGoodsProperty_find
             LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
       )
     , tmpObject_GoodsPropertyValue_basis AS
       (SELECT ObjectLink_GoodsPropertyValue_Goods.ObjectId      AS ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
        FROM (SELECT vbGoodsPropertyId_basis AS GoodsPropertyId
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             INNER JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                           AND Object_GoodsPropertyValue.ValueData <> ''

             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                   ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectLink_GoodsPropertyValue_Goods.DescId   = zc_ObjectLink_GoodsPropertyValue_Goods()
             INNER JOIN tmpGoods ON tmpGoods.GoodsId = ObjectLink_GoodsPropertyValue_Goods.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )
     , tmpObject_GoodsPropertyValueGroup_basis AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.Name
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue_basis AS tmpObject_GoodsPropertyValue WHERE Name <> '' GROUP BY GoodsId
             ) AS tmpGoodsProperty_find
             LEFT JOIN tmpObject_GoodsPropertyValue_basis AS tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
       )
       -- результат
       SELECT
             Object_Goods.ObjectCode                AS GoodsCode

           , CASE WHEN Movement.OperDate < '01.01.2017'
                       THEN ''

                  -- !!!!
                  WHEN MovementBoolean_isUKTZ_new.ValueData = TRUE AND ObjectString_Goods_UKTZED_new.ValueData <> ''
                       THEN CASE WHEN vbIsLongUKTZED = TRUE THEN ObjectString_Goods_UKTZED_new.ValueData ELSE SUBSTRING (ObjectString_Goods_UKTZED_new.ValueData FROM 1 FOR 4) END

                  -- !!!!
                  WHEN MovementBoolean_isUKTZ_new.ValueData = TRUE AND tmpUKTZED_new.CodeUKTZED                <> ''
                       THEN CASE WHEN vbIsLongUKTZED = TRUE THEN tmpUKTZED_new.CodeUKTZED ELSE SUBSTRING (tmpUKTZED_new.CodeUKTZED FROM 1 FOR 4) END
                  

                  -- на дату у товара
                  WHEN ObjectString_Goods_UKTZED_new.ValueData <> '' AND ObjectDate_Goods_UKTZED_new.ValueData <= vbOperDate_Tax_Tax
                       THEN CASE WHEN vbIsLongUKTZED = TRUE THEN ObjectString_Goods_UKTZED_new.ValueData ELSE SUBSTRING (ObjectString_Goods_UKTZED_new.ValueData FROM 1 FOR 4) END
                  -- у товара
                  WHEN ObjectString_Goods_UKTZED.ValueData <> ''
                       THEN CASE WHEN vbIsLongUKTZED = TRUE THEN ObjectString_Goods_UKTZED.ValueData ELSE SUBSTRING (ObjectString_Goods_UKTZED.ValueData FROM 1 FOR 4) END
                  -- на дату у группы товара
                  WHEN tmpUKTZED.CodeUKTZED <> ''
                       THEN CASE WHEN vbIsLongUKTZED = TRUE THEN tmpUKTZED.CodeUKTZED ELSE SUBSTRING (tmpUKTZED.CodeUKTZED FROM 1 FOR 4) END

                  -- для предоплаты
                  WHEN vbDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay()
                       THEN '1601009900'

                  WHEN ObjectString_Goods_UKTZED_new.ValueData <> ''
                       THEN ObjectString_Goods_UKTZED_new.ValueData

                  WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101())
                       THEN '' -- '1601'
                  WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_21001(), zc_Enum_InfoMoney_30102())
                       THEN '' -- '1602'
                  WHEN ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30103()
                       THEN '' -- '1905'
                  ELSE '' -- '0'
              END :: TVarChar AS GoodsCodeUKTZED

           , CASE WHEN Movement.OperDate < '01.03.2017' THEN ''
                  WHEN ObjectString_Goods_TaxImport.ValueData <> '' THEN ObjectString_Goods_TaxImport.ValueData
                  WHEN tmpTaxImport.TaxImport <> '' THEN tmpTaxImport.TaxImport
                  ELSE ''
             END :: TVarChar AS GoodsCodeTaxImport

           , CASE WHEN Movement.OperDate < '01.03.2017' THEN ''
                  WHEN ObjectString_Goods_DKPP.ValueData <> '' THEN ObjectString_Goods_DKPP.ValueData
                  WHEN tmpDKPP.DKPP <> '' THEN tmpDKPP.DKPP
                  ELSE ''
             END :: TVarChar AS GoodsCodeDKPP

           , CASE WHEN Movement.OperDate < '01.03.2017' THEN ''
                  WHEN ObjectString_Goods_TaxAction.ValueData <> '' THEN ObjectString_Goods_TaxAction.ValueData
                  WHEN tmpTaxAction.TaxAction <> '' THEN tmpTaxAction.TaxAction
                  ELSE ''
             END :: TVarChar AS GoodsCodeTaxAction

           , (CASE WHEN vbDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay() AND vbInfoMoneyId <> zc_Enum_InfoMoney_30201()
                        THEN CASE WHEN vbOperDate_begin >= '01.12.2018' AND COALESCE (vbGoods_DocumentTaxKind, '') <> '' THEN vbGoods_DocumentTaxKind
                                  ELSE 'ПРЕДОПЛАТА ЗА КОЛБ.ИЗДЕЛИЯ'
                             END
                   ELSE CASE WHEN tmpObject_GoodsPropertyValue.Name <> ''
                                  THEN tmpObject_GoodsPropertyValue.Name
                             WHEN tmpObject_GoodsPropertyValueGroup.Name <> ''
                                  THEN tmpObject_GoodsPropertyValueGroup.Name
                             WHEN tmpObject_GoodsPropertyValue_basis.Name <> ''
                                  THEN tmpObject_GoodsPropertyValue_basis.Name
                             WHEN tmpObject_GoodsPropertyValueGroup_basis.Name <> ''
                                  THEN tmpObject_GoodsPropertyValueGroup_basis.Name
                             ELSE CASE WHEN vbOperDate_rus < zc_DateEnd_GoodsRus() AND ObjectString_Goods_RUS.ValueData <> '' THEN ObjectString_Goods_RUS.ValueData 
                                  ELSE  /*CASE WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData END*/
                                       CASE -- WHEN vbUserId = 5 THEN (vbOperDate_begin >= ObjectDate_BUH.ValueData) :: TVarChar
                                            WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate_begin >= ObjectDate_BUH.ValueData THEN Object_Goods.ValueData
                                            WHEN tmpMI.isName_new = TRUE THEN Object_Goods.ValueData
                                            WHEN ObjectString_Goods_BUH.ValueData <>'' THEN ObjectString_Goods_BUH.ValueData
                                            ELSE Object_Goods.ValueData
                                       END
                                  END || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN ''
                                         ELSE ' ' || Object_GoodsKind.ValueData
                                         END
                        END
              END) :: TVarChar AS GoodsName

           , (CASE WHEN vbDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay() AND vbInfoMoneyId <> zc_Enum_InfoMoney_30201()
                        THEN CASE WHEN vbOperDate_begin >= '01.12.2018' AND COALESCE (vbGoods_DocumentTaxKind, '') <> '' THEN vbGoods_DocumentTaxKind
                                  ELSE 'ПРЕДОПЛАТА ЗА КОЛБ.ИЗДЕЛИЯ'
                             END
                   ELSE CASE WHEN tmpObject_GoodsPropertyValue.Name <> ''
                                  THEN tmpObject_GoodsPropertyValue.Name
                             WHEN tmpObject_GoodsPropertyValueGroup.Name <> ''
                                  THEN tmpObject_GoodsPropertyValueGroup.Name
                             WHEN tmpObject_GoodsPropertyValue_basis.Name <> ''
                                  THEN tmpObject_GoodsPropertyValue_basis.Name
                             WHEN tmpObject_GoodsPropertyValueGroup_basis.Name <> ''
                                  THEN tmpObject_GoodsPropertyValueGroup_basis.Name
                             ELSE CASE WHEN vbOperDate_rus < zc_DateEnd_GoodsRus() AND ObjectString_Goods_RUS.ValueData <> '' THEN ObjectString_Goods_RUS.ValueData 
                                  ELSE /*CASE WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData END*/
                                       CASE WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate_begin >= ObjectDate_BUH.ValueData THEN Object_Goods.ValueData
                                            WHEN tmpMI.isName_new = TRUE THEN Object_Goods.ValueData
                                            WHEN ObjectString_Goods_BUH.ValueData <>'' THEN ObjectString_Goods_BUH.ValueData
                                            ELSE Object_Goods.ValueData
                                       END
                                  END
                        END
             END) :: TVarChar AS GoodsName_two

           , Object_GoodsKind.ValueData             AS GoodsKindName

           , CASE WHEN vbDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay() AND vbInfoMoneyId <> zc_Enum_InfoMoney_30201() AND vbOperDate_begin >= '01.12.2018' AND COALESCE (vbMeasure_DocumentTaxKind, '') <> ''
                  THEN vbMeasure_DocumentTaxKind
                  ELSE Object_Measure.ValueData
             END              AS MeasureName

           , CASE WHEN vbDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay() AND vbInfoMoneyId <> zc_Enum_InfoMoney_30201() AND vbOperDate_begin >= '01.12.2018' AND COALESCE (vbMeasureCode_DocumentTaxKind, '') <> ''
                  THEN vbMeasureCode_DocumentTaxKind
                  ELSE CASE WHEN Object_Measure.ObjectCode=1 THEN '0301'
                            WHEN Object_Measure.ObjectCode IN (2, 102) THEN '2009'
                            ELSE ''     
                       END 
             END                             AS MeasureCode

           , tmpMI.Amount                    AS Amount
           , tmpMI.Amount                    AS AmountPartner
           , tmpMI.Price
           , tmpMI.CountForPrice

           , COALESCE (tmpObject_GoodsPropertyValue.Name, tmpObject_GoodsPropertyValueGroup.Name, '')                  AS GoodsName_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, '')) AS Article_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCode, '')    AS BarCode_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.ArticleGLN, COALESCE (tmpObject_GoodsPropertyValue.ArticleGLN, '')) AS ArticleGLN_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCodeGLN, '') AS BarCodeGLN_Juridical

           , CAST (CASE WHEN tmpMI.CountForPrice > 0
                           THEN CAST (tmpMI.Amount * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                        ELSE CAST (tmpMI.Amount * tmpMI.Price AS NUMERIC (16, 2))
                   END AS TFloat) AS AmountSumm

           , CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 4))
                  ELSE tmpMI.Price
             END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceNoVAT

           , CASE WHEN vbPriceWithVAT = FALSE
                  THEN CAST (tmpMI.Price + tmpMI.Price * (vbVATPercent / 100) AS NUMERIC (16, 4))
                  ELSE tmpMI.Price
             END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceWVAT

           , CAST (CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis()
                             THEN tmpMI.Amount * CASE WHEN vbPriceWithVAT = TRUE
                                                                  THEN (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100)))
                                                                  ELSE tmpMI.Price
                                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                             ELSE 0
                   END AS NUMERIC (16, 2)) AS AmountSummNoVAT
           , CAST (CASE WHEN vbCurrencyPartnerId <> zc_Enum_Currency_Basis()
                             THEN tmpMI.Amount * CASE WHEN vbPriceWithVAT = TRUE
                                                                  THEN (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100)))
                                                                  ELSE tmpMI.Price
                                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                             ELSE 0
                   END AS NUMERIC (16, 2)) AS AmountSummNoVAT_11

           , CAST (tmpMI.Amount * CASE WHEN vbPriceWithVAT = FALSE
                                              THEN tmpMI.Price + tmpMI.Price * (vbVATPercent / 100)
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 3)) AS AmountSummWVAT

           , CAST (tmpMI.Amount * CASE WHEN vbPriceWithVAT = TRUE
                                              THEN (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100)))
                                              ELSE tmpMI.Price
                                          END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 2)) AS AmountSummNoVAT_12
           -- Сума податку на додану вартість
           , CAST (CAST(tmpMI.Amount * CASE WHEN vbPriceWithVAT = TRUE
                                           THEN (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100)))
                                           ELSE (tmpMI.Price)
                                       END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                    AS NUMERIC (16, 2))  / 100 * vbVATPercent 
                   AS NUMERIC (16, 6)) AS SummVAT
       FROM tmpMI

            LEFT JOIN MovementBoolean AS MovementBoolean_isUKTZ_new
                                      ON MovementBoolean_isUKTZ_new.MovementId = tmpMI.MovementId
                                     AND MovementBoolean_isUKTZ_new.DescId     = zc_MovementBoolean_UKTZ_new()

            LEFT JOIN tmpUKTZED     ON tmpUKTZED.GoodsGroupId     = tmpMI.GoodsGroupId
            LEFT JOIN tmpUKTZED_new ON tmpUKTZED_new.GoodsGroupId = tmpMI.GoodsGroupId
            LEFT JOIN tmpTaxImport ON tmpTaxImport.GoodsGroupId = tmpMI.GoodsGroupId
            LEFT JOIN tmpDKPP ON tmpDKPP.GoodsGroupId = tmpMI.GoodsGroupId
            LEFT JOIN tmpTaxAction ON tmpTaxAction.GoodsGroupId = tmpMI.GoodsGroupId

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

            LEFT JOIN ObjectString AS ObjectString_Goods_TaxImport
                                   ON ObjectString_Goods_TaxImport.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_TaxImport.DescId = zc_ObjectString_Goods_TaxImport()
            LEFT JOIN ObjectString AS ObjectString_Goods_DKPP
                                   ON ObjectString_Goods_DKPP.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_DKPP.DescId = zc_ObjectString_Goods_DKPP()
            LEFT JOIN ObjectString AS ObjectString_Goods_TaxAction
                                   ON ObjectString_Goods_TaxAction.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_TaxAction.DescId = zc_ObjectString_Goods_TaxAction()

            LEFT JOIN ObjectString AS ObjectString_Goods_RUS
                                   ON ObjectString_Goods_RUS.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_RUS.DescId = zc_ObjectString_Goods_RUS()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = tmpMI.GoodsId
                                                       AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = tmpMI.GoodsId
                                                        AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = tmpMI.GoodsKindId
            LEFT JOIN tmpObject_GoodsPropertyValueGroup_basis ON tmpObject_GoodsPropertyValueGroup_basis.GoodsId = tmpMI.GoodsId
                                                             AND tmpObject_GoodsPropertyValue_basis.GoodsId IS NULL

            LEFT JOIN Movement ON Movement.Id = tmpMI.MovementId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            -- LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

       ORDER BY CASE WHEN NOT EXISTS (SELECT 1 FROM tmpMI WHERE tmpMI.NPP = 0)
                          THEN tmpMI.NPP
                     ELSE 0
                END
              , CASE WHEN vbOperDate_rus < zc_DateEnd_GoodsRus() AND ObjectString_Goods_RUS.ValueData <> ''
                          THEN ObjectString_Goods_RUS.ValueData
                     ELSE /*CASE WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData END*/
                          CASE WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate_begin >= ObjectDate_BUH.ValueData THEN ObjectString_Goods_BUH.ValueData
                               WHEN tmpMI.isName_new = TRUE THEN Object_Goods.ValueData
                               ELSE Object_Goods.ValueData
                          END
                END
              , Object_GoodsKind.ValueData
              , tmpMI.Id
      ;
     RETURN NEXT Cursor2;


     -- Данные по разнице Продажи и Налоговой
     OPEN Cursor3 FOR
     WITH
     tmpMovementTaxCount AS
     (
     SELECT CASE
            WHEN (vbMovementId_Sale <> 0 AND vbMovementId_Tax<>0 AND MovementLinkObject_DocumentTaxKind.ObjectId=80787)--тип-налоговой 80787=налоговая простая
            THEN 1 ELSE 0 END                       AS CountTaxId
     FROM MovementLinkObject AS MovementLinkObject_DocumentTaxKind
     WHERE MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
       AND MovementLinkObject_DocumentTaxKind.MovementId = vbMovementId_Tax
     )
     ,
     tmpTax AS
      (SELECT MovementItem.ObjectId                  AS GoodsId
            , MIFloat_Price.ValueData                AS Price
            , SUM (MovementItem.Amount)              AS Amount
       FROM MovementItem
            INNER JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                        -- AND MIFloat_Price.ValueData <> 0
       WHERE MovementItem.MovementId = vbMovementId_Tax
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = FALSE
       GROUP BY MovementItem.ObjectId
              , MIFloat_Price.ValueData
      )
    , tmpSale AS
       (SELECT MovementItem.ObjectId     			AS GoodsId
             , CASE WHEN MovementFloat_ChangePercent.ValueData <> 0
                         THEN CAST ( (1 + MovementFloat_ChangePercent.ValueData / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                    ELSE COALESCE (MIFloat_Price.ValueData, 0)
               END AS Price
             , SUM (CASE WHEN Movement.DescId = zc_Movement_Sale()
                              THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                              ELSE MovementItem.Amount
                    END) AS Amount
       FROM MovementItem
            INNER JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                        -- AND MIFloat_Price.ValueData <> 0
            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
            LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId = MovementItem.MovementId
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
       WHERE MovementItem.MovementId = vbMovementId_Sale
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = FALSE
       GROUP BY MovementItem.ObjectId
              , MIFloat_Price.ValueData
              , MovementFloat_ChangePercent.ValueData
      )

       SELECT GoodsId
            , Object_Goods.ObjectCode        AS GoodsCode
            , Object_Goods.ValueData         AS GoodsName
            , Price                          AS Price
            , CAST (COALESCE(tmpMovementTaxCount.CountTaxId, 0) AS Integer) AS CountTaxId
            , SUM (SaleAmount)               AS SaleAmount
            , SUM (TaxAmount)                AS TaxAmount
       FROM (SELECT tmpSale.GoodsId
                  , tmpSale.Price
                  , tmpSale.Amount AS SaleAmount
                  , 0              AS TaxAmount
             FROM tmpSale
             WHERE tmpSale.Amount <> 0
           UNION ALL
             SELECT tmpTax.GoodsId
                  , tmpTax.Price
                  , 0             AS SaleAmount
                  , tmpTax.Amount AS TaxAmount
             FROM tmpTax
          ) AS tmp
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id =  tmp.GoodsId
           LEFT JOIN tmpMovementTaxCount ON 1=1
       GROUP BY tmp.GoodsId
              , Object_Goods.ObjectCode
              , Object_Goods.ValueData
              , tmp.Price
              , tmpMovementTaxCount.CountTaxId
       HAVING SUM (tmp.SaleAmount) <>  SUM (tmp.TaxAmount)
      ;
     RETURN NEXT Cursor3;


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
             , 'gpSelect_Movement_Tax_Print'
               -- ProtocolData
             , inMovementId        :: TVarChar
    || ', ' || inisClientCopy      :: TVarChar
    || ', ' || inSession
              ;*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Tax_Print (Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.09.21         * 
 29.01.19         *
 05.11.18         *
 04.03.18         * MovementString_ToINN.ValueData
 10.03.17         *
 06.01.17         * GoodsCodeUKTZED
 29.01.16         *
 21.04.15                        * add MovementDate_COMDOC
 14.01.15                                                       *
 30.12.14                                                       * add MeasureCode
 23.07.14                                        * add tmpObject_GoodsPropertyValueGroup and ArticleGLN
 05.06.14                                        * restore ContractSigningDate
 04.06.14                                        * add tmpObject_GoodsPropertyValue.Name
 21.05.14                                        * add zc_Movement_TransferDebtOut
 20.05.14                                        * ContractSigningDate -> Object_Contract_View.StartDate
 19.05.14                                        * add MovementFloat_ChangePercent
 17.05.14                                        * add StatusId = zc_Enum_Status_Complete
 13.05.14                                        * add calc GoodsName
 07.05.14                       * add CHARCODE
 24.04.14                                                       * add zc_MovementString_InvNumberBranch
 11.04.14                                                       *
 02.04.14                                                       *  PriceWVAT PriceNoVAT round to 2 sign
 01.04.14                                                       *  MIFloat_Price.ValueData <> 0
 31.03.14                                                       *  + inisClientCopy
 23.03.14                                        * rename zc_MovementLinkMovement_Child -> zc_MovementLinkMovement_Master
 06.03.14                                                       *
 24.02.14                                                       *  add PriceNoVAT, PriceWVAT, AmountSummNoVAT, AmountSummWVAT
 19.02.14                                                       *  add by juridical
 07.02.14                                                       *  change to Cursor
 05.02.14                                                       *
*/

/*

по законодательству, все налоговые документы, которые ВЫГРУЖАЮТСЯ в Медок  и регистрируются с 01.04 - должны быть в новой форме.
С 01.04 мы также будем продолжать регистрировать и документы марта. Все сводные 100%.
Форма действует на на документы с датой с 01.04, а не регистрацию всех документов с 01.04

1) п.1.Если в сводной нн этого месяца нет №пп этой позиции, значит она отгружалась в предыдущих месяцах.
Необходимо сделать автоматическую "правильную" привязку позиций в сводных корректировках. Будет столько сводных корректировок за месяц у покупателя, к скольким сводным сформируются сводные корректировки (в скольких разных месяцах  были отгрузки возвращаемых товаров).
2) а на еще 20  позиций -  №п/п не определен однозначно, т.е. в налоговой разные виды упаковки, дальнейшие действия бухгалтера:
- открыть налоговую для определения в ручном режиме № п/п по необходимым позициям
- ввести в корректировку эти № п/п

новая форма зависит не только от даты налоговой или корр, еще и от значения "дата регистрации"  - причем даже когда документ не зарегистрирован, поэтому для проверки не обязательно создавать все в апреле ... можно менять эту дату
ВАЖНО - "дата регистрации" автоматом устанавливается в след случаях:
- при создании налоговых док-тов с 1 апреля (там будет дата создания)
- при выгрузке в медок (там будет дата выгрузки)
- при загрузке с медка регистрации (там будет реальная дата регистрации)

не совсем нормально, В.С. сказал что инфа о регистрации в марте может прийти и позже , 2,3 апреля, поэтому контрольная точка будет наверно в понедельник, созваниваться смысла нет
тестировать медок - да, 01 апреля, но главное что б у вас не было налоговых, по которым срок регистрации заканчивается 1-2 апреля, с В.С. даже говорили что не должно быть таких до 5 апреля

*/

-- тест
-- SELECT * FROM gpSelect_Movement_Tax_Print (inMovementId:= 171760, inisClientCopy:= FALSE, inSession:= zfCalc_UserAdmin()); -- FETCH ALL "<unnamed portal 1>";
