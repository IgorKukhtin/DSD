-- Function: gpSelect_Movement_OrderExternal_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderExternal_Print (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderExternal_Print (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderExternal_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inIsJuridical       Boolean  , -- печать итого по Юр лицу - печать всех заявок по юр.дицу за этот день
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;

    DECLARE vbDescId              Integer;
    DECLARE vbStatusId            Integer;
    DECLARE vbPriceWithVAT        Boolean;
    DECLARE vbVATPercent          TFloat;
    DECLARE vbDiscountPercent     TFloat;
    DECLARE vbExtraChargesPercent TFloat;
    DECLARE vbContractId          Integer;
    DECLARE vbRetailId            Integer;
    DECLARE vbFromId              Integer;
    DECLARE vbUnitId              Integer;
    DECLARE vbJuridicalId         Integer;
    DECLARE vbOperDate            TDateTime;
    DECLARE vbIsOrderByLine       Boolean;
    DECLARE vbIsRemains           Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE)  AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)         AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END  AS ExtraChargesPercent
          , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_From.ObjectId), COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_From.ObjectId)) AS GoodsPropertyId
          , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)      AS GoodsPropertyId_basis
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0)       AS ContractId
          , COALESCE (MovementLinkObject_Retail.ObjectId, 0)         AS RetailId
          , COALESCE (MovementLinkObject_From.ObjectId, 0)           AS FromId
          , COALESCE (MovementLinkObject_To.ObjectId, 0)             AS UnitId
          , ObjectLink_Partner_Juridical.ChildObjectId               AS JuridicalId
          , CASE WHEN Movement.AccessKeyId IN (zc_Enum_Process_AccessKey_DocumentKiev(), zc_Enum_Process_AccessKey_DocumentLviv()) THEN TRUE ELSE FALSE END AS isOrderByLine
          , COALESCE (MovementBoolean_Remains.ValueData, FALSE) ::Boolean AS isRemains

            INTO vbDescId, vbStatusId, vbOperDate, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent
               , vbGoodsPropertyId, vbGoodsPropertyId_basis, vbContractId, vbRetailId, vbFromId, vbUnitId, vbJuridicalId, vbIsOrderByLine
               , vbIsRemains
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
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                       ON MovementLinkObject_Retail.MovementId = Movement.Id
                                      AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                       ON MovementLinkObject_Partner.MovementId = Movement.Id
                                      AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                      AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_From.ObjectId)
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

          LEFT JOIN MovementBoolean AS MovementBoolean_Remains
                                    ON MovementBoolean_Remains.MovementId = Movement.Id
                                   AND MovementBoolean_Remains.DescId = zc_MovementBoolean_Remains()

     WHERE Movement.Id = inMovementId;



-- if vbUserId = 5
-- then
--     RAISE EXCEPTION '<%>', lfGet_Object_ValueData(vbGoodsPropertyId);
-- end if;

     -- очень важная проверка
     IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete() AND vbUserId <> 5
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


    -- таб. документов    -- параметры из документов
    CREATE TEMP TABLE tmpListDoc (MovementId Integer) ON COMMIT DROP;
    INSERT INTO tmpListDoc (MovementId)
          SELECT inMovementId AS Id
          WHERE inIsJuridical = FALSE
         UNION
          SELECT Movement.Id AS Id
          FROM Movement
               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
               INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                     ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                    AND ObjectLink_Partner_Juridical.ChildObjectId = vbJuridicalId
          WHERE Movement.DescId = zc_Movement_OrderExternal()
            AND Movement.OperDate = vbOperDate
            AND inIsJuridical = TRUE;


      --
     OPEN Cursor1 FOR
       WITH tmpMovement AS (SELECT tmp.MovementId
                            FROM (
                                  SELECT Movement_find.Id AS MovementId
                                  FROM (SELECT inMovementId AS MovementId WHERE vbRetailId <> 0) AS tmpMovement
                                       INNER JOIN Movement ON Movement.Id = tmpMovement.MovementId
                                       INNER JOIN Movement AS Movement_find ON Movement_find.OperDate = Movement.OperDate
                                                                           AND Movement_find.DescId   = Movement.DescId
                                                                           AND Movement_find.StatusId = zc_Enum_Status_Complete()
                                       INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                                     ON MovementLinkObject_From_find.MovementId = Movement_find.Id
                                                                    AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                                                                    AND MovementLinkObject_From_find.ObjectId = vbFromId
                                       INNER JOIN MovementLinkObject AS MovementLinkObject_Retail_find
                                                                     ON MovementLinkObject_Retail_find.MovementId = Movement_find.Id
                                                                    AND MovementLinkObject_Retail_find.DescId = zc_MovementLinkObject_Retail()
                                                                    AND MovementLinkObject_Retail_find.ObjectId = vbRetailId
                                 UNION
                                  SELECT inMovementId AS MovementId WHERE vbRetailId = 0
                                  ) AS tmp
                            WHERE inisJuridical = FALSE
                           UNION
                            SELECT tmpListDoc.MovementId
                            FROM tmpListDoc
                            WHERE inisJuridical = TRUE
                           )

          , tmpMF AS (SELECT MovementFloat.*
                      FROM MovementFloat
                      WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement)
                         AND MovementFloat.DescId IN (zc_MovementFloat_TotalCount()
                                                    , zc_MovementFloat_TotalCountKg()
                                                    , zc_MovementFloat_TotalCountSh()
                                                    , zc_MovementFloat_TotalSummMVAT()
                                                    , zc_MovementFloat_TotalSummPVAT()
                                                    , zc_MovementFloat_TotalSumm())
                      )

          , tmpMovement_total AS (SELECT MAX (tmpMovement.MovementId) AS MovementId
                                       , STRING_AGG (COALESCE (Movement.InvNumber, '*'), ', ')          AS InvNumber
                                       , COUNT (DISTINCT tmpMovement.MovementId)                        AS CountOrder
                                       , SUM (COALESCE (MovementFloat_TotalCount.ValueData, 0))         AS TotalCount
                                       , SUM (COALESCE (MovementFloat_TotalCountKg.ValueData, 0))       AS TotalCountKg
                                       , SUM (COALESCE (MovementFloat_TotalCountSh.ValueData, 0))       AS TotalCountSh

                                       , SUM (COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0))      AS TotalSummMVAT
                                       , SUM (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0))      AS TotalSummPVAT
                                       , SUM (COALESCE (MovementFloat_TotalSummPVAT.ValueData) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0)) AS SummVAT
                                       , SUM (COALESCE (MovementFloat_TotalSumm.ValueData, 0))          AS TotalSumm
                                  FROM tmpMovement
                                       LEFT JOIN Movement ON Movement.Id =  tmpMovement.MovementId
                                       LEFT JOIN tmpMF AS MovementFloat_TotalCount
                                                       ON MovementFloat_TotalCount.MovementId =  tmpMovement.MovementId
                                                      AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
                                       LEFT JOIN tmpMF AS MovementFloat_TotalCountKg
                                                       ON MovementFloat_TotalCountKg.MovementId =  tmpMovement.MovementId
                                                      AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
                                       LEFT JOIN tmpMF AS MovementFloat_TotalCountSh
                                                       ON MovementFloat_TotalCountSh.MovementId =  tmpMovement.MovementId
                                                      AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()

                                       LEFT JOIN tmpMF AS MovementFloat_TotalSummMVAT
                                                       ON MovementFloat_TotalSummMVAT.MovementId =  tmpMovement.MovementId
                                                      AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
                                       LEFT JOIN tmpMF AS MovementFloat_TotalSummPVAT
                                                       ON MovementFloat_TotalSummPVAT.MovementId =  tmpMovement.MovementId
                                                      AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
                                       LEFT JOIN tmpMF AS MovementFloat_TotalSumm
                                                       ON MovementFloat_TotalSumm.MovementId =  tmpMovement.MovementId
                                                      AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                 )
          , tmpMLO AS (SELECT MovementLinkObject.*
                       FROM MovementLinkObject
                       WHERE MovementLinkObject.MovementId IN (SELECT MAX (tmpMovement.MovementId) AS MovementId FROM tmpMovement)
                         AND MovementLinkObject.DescId IN (zc_MovementLinkObject_From()
                                                           , zc_MovementLinkObject_To()
                                                           , zc_MovementLinkObject_PaidKind()
                                                           , zc_MovementLinkObject_Personal()
                                                           , zc_MovementLinkObject_Route()
                                                           , zc_MovementLinkObject_RouteSorting()
                                                           , zc_MovementLinkObject_Partner()
                                                           , zc_MovementLinkObject_Contract()
                                                           , zc_MovementLinkObject_ContractFrom())
                        )

          , tmpMovementDate AS (SELECT MovementDate.*
                                FROM MovementDate
                                WHERE MovementDate.MovementId IN (SELECT MAX (tmpMovement.MovementId) AS MovementId FROM tmpMovement)
                                  AND MovementDate.DescId IN (zc_MovementDate_OperDatePartner()
                                                            , zc_MovementDate_OperDateMark())
                               )

          , tmpMovementString AS (SELECT MovementString.*
                                  FROM MovementString
                                  WHERE MovementString.MovementId IN (SELECT MAX (tmpMovement.MovementId) AS MovementId FROM tmpMovement)
                                    AND MovementString.DescId IN (zc_MovementString_InvNumberPartner()
                                                                , zc_MovementString_Comment())
                                )
      -- Результат
      SELECT Movement.Id                                AS Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
           , tmpMovement_total.CountOrder ::Integer     AS CountOrder
           , tmpMovement_total.InvNumber  ::Text        AS InvNumber
           , Movement.OperDate                          AS OperDate
           , MovementDate_OperDatePartner.ValueData     AS OperDatePartner
           , CASE WHEN MovementDate_OperDateMark.ValueData >= Movement.OperDate THEN 'Дата маркировки : ' || (DATE (MovementDate_OperDateMark.ValueData) :: TVarChar) ELSE '' END AS OperDateMark

           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
           , MovementString_Comment.ValueData           AS Comment

           , vbPriceWithVAT                             AS PriceWithVAT
           , vbVATPercent                               AS VATPercent
           , vbExtraChargesPercent - vbDiscountPercent  AS ChangePercent

           , tmpMovement_total.TotalCount
           , tmpMovement_total.TotalCountKg
           , tmpMovement_total.TotalCountSh

           , tmpMovement_total.TotalSummMVAT
           , tmpMovement_total.TotalSummPVAT
           , tmpMovement_total.SummVAT
           , tmpMovement_total.TotalSumm

           , Object_Partner.ValueData                   AS PartnerName
           , Object_From.ObjectCode                     AS FromCode
           , Object_From.ValueData                      AS FromName
           , Object_To.ValueData               		    AS ToName
           , Object_PaidKind.ValueData         		    AS PaidKindName
           , View_Contract.InvNumber        		    AS ContractName
           , View_Contract.ContractTagName              AS ContractTagName

           , OH_JuridicalDetails_From.FullName          AS JuridicalName_From
           , OH_JuridicalDetails_From.JuridicalAddress  AS JuridicalAddress_From
           , OH_JuridicalDetails_From.OKPO              AS OKPO_From

           , OH_JuridicalDetails_To.FullName            AS JuridicalName_To
           , OH_JuridicalDetails_To.JuridicalAddress    AS JuridicalAddress_To
           , OH_JuridicalDetails_To.OKPO                AS OKPO_To

           , Object_Personal.ValueData                  AS PersonalName
           , Object_Route.ValueData                     AS RouteName
           , Object_RouteSorting.ValueData              AS RouteSortingName

           , vbIsOrderByLine                            AS isOrderByLine

             -- Розподільчий комплекс
           , CASE WHEN Object_To.Id = 8459 THEN FALSE ELSE TRUE END :: Boolean AS isPage_1

       FROM tmpMovement_total
            LEFT JOIN Movement ON Movement.Id = tmpMovement_total.MovementId

            LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                      ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN tmpMovementDate AS MovementDate_OperDateMark
                                      ON MovementDate_OperDateMark.MovementId =  Movement.Id
                                     AND MovementDate_OperDateMark.DescId = zc_MovementDate_OperDateMark()
            LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                        ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                       AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN tmpMovementString AS MovementString_Comment
                                        ON MovementString_Comment.MovementId = Movement.Id
                                       AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN tmpMLO AS MovementLinkObject_From
                             ON MovementLinkObject_From.MovementId = Movement.Id
                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_To
                             ON MovementLinkObject_To.MovementId = Movement.Id
                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_PaidKind
                             ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                            AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId


            LEFT JOIN tmpMLO AS MovementLinkObject_Contract
                             ON MovementLinkObject_Contract.MovementId = Movement.Id
                            AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractFrom())

            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = MovementLinkObject_Contract.ObjectId

            -- по контрагенту находим юр.лицо
           /* LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
           */
            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = vbJuridicalId --ObjectLink_Partner_Juridical.ChildObjectId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_From.EndDate

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                ON OH_JuridicalDetails_To.JuridicalId = View_Contract.JuridicalBasisId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate

            LEFT JOIN tmpMLO AS MovementLinkObject_Personal
                             ON MovementLinkObject_Personal.MovementId = Movement.Id
                            AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_Route
                             ON MovementLinkObject_Route.MovementId = Movement.Id
                            AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_RouteSorting
                             ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                            AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_Partner
                             ON MovementLinkObject_Partner.MovementId = Movement.Id
                            AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                            AND vbRetailId = 0
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = COALESCE (MovementLinkObject_Partner.ObjectId, vbRetailId)
      ;
    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
       WITH -- Остатки
            tmpRemains AS (SELECT Container.ObjectId                          AS GoodsId
                                , SUM (Container.Amount)                      AS Amount
                                , COALESCE (CLO_GoodsKind.ObjectId, 0)        AS GoodsKindId
                           FROM ContainerLinkObject AS CLO_Unit
                                INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count() AND Container.Amount <> 0
                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                              ON CLO_GoodsKind.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                LEFT JOIN ContainerLinkObject AS CLO_Account
                                                              ON CLO_Account.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                           WHERE CLO_Unit.ObjectId = vbUnitId
                             AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                             AND CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                           GROUP BY Container.ObjectId
                                  , COALESCE (CLO_GoodsKind.ObjectId, 0)
                          )
          , tmpObject_GoodsPropertyValue AS
       (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId      AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectFloat_Amount.ValueData         AS Amount
             , ObjectFloat_BoxCount.ValueData       AS BoxCount
             , ObjectString_BarCode.ValueData       AS BarCode
             , ObjectString_Article.ValueData       AS Article
             , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
             , ObjectString_ArticleGLN.ValueData    AS ArticleGLN
             , ObjectString_CodeSticker.ValueData   AS CodeSticker
             , ObjectString_Goods_ShortName.ValueData AS GoodsBoxName_short
        FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                   ON ObjectFloat_Amount.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()

             LEFT JOIN ObjectFloat AS ObjectFloat_BoxCount
                                   ON ObjectFloat_BoxCount.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectFloat_BoxCount.DescId = zc_ObjectFloat_GoodsPropertyValue_BoxCount()

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
             LEFT JOIN ObjectString AS ObjectString_CodeSticker
                                    ON ObjectString_CodeSticker.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_CodeSticker.DescId = zc_ObjectString_GoodsPropertyValue_CodeSticker()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsBox
                                  ON ObjectLink_GoodsPropertyValue_GoodsBox.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsBox.DescId   = zc_ObjectLink_GoodsPropertyValue_GoodsBox()
             LEFT JOIN ObjectString AS ObjectString_Goods_ShortName
                                    ON ObjectString_Goods_ShortName.ObjectId = ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId
                                   AND ObjectString_Goods_ShortName.DescId   = zc_ObjectString_Goods_ShortName()

        WHERE Object_GoodsPropertyValue.ValueData    <> ''
           OR ObjectString_BarCode.ValueData         <> ''
           OR ObjectString_Article.ValueData         <> ''
           OR ObjectString_BarCodeGLN.ValueData      <> ''
           OR ObjectString_ArticleGLN.ValueData      <> ''
           OR ObjectString_CodeSticker.ValueData     <> ''
           OR ObjectString_Goods_ShortName.ValueData <> ''
           OR ObjectFloat_BoxCount.ValueData         <> 0
       )
    /*, tmpObject_GoodsPropertyValueGroup AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.Article
           --, tmpObject_GoodsPropertyValue.BoxCount
           --, tmpObject_GoodsPropertyValue.GoodsBoxName_short
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue
              WHERE Article <> '' OR ArticleGLN <> ''
              GROUP BY GoodsId
             ) AS tmpGoodsProperty_find
             LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
       )*/
     , tmpObject_GoodsPropertyValueGroup_GoodsBoxName_short AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.GoodsBoxName_short
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId
              FROM tmpObject_GoodsPropertyValue
              WHERE GoodsBoxName_short <> ''
                AND tmpObject_GoodsPropertyValue.GoodsKindId IN (0, zc_GoodsKind_Basis())
              GROUP BY GoodsId
             ) AS tmpGoodsProperty_find
             LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
       )
     , tmpObject_GoodsPropertyValueGroup_BoxCount AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.BoxCount
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId
              FROM tmpObject_GoodsPropertyValue
              WHERE BoxCount <> 0
                AND tmpObject_GoodsPropertyValue.GoodsKindId IN (0, zc_GoodsKind_Basis())
                AND 1=0
              GROUP BY GoodsId
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
          , tmpMovement AS (SELECT tmp.MovementId
                            FROM (
                                  SELECT Movement_find.Id AS MovementId
                                  FROM (SELECT inMovementId AS MovementId WHERE vbRetailId <> 0) AS tmpMovement
                                       INNER JOIN Movement ON Movement.Id = tmpMovement.MovementId
                                       INNER JOIN Movement AS Movement_find ON Movement_find.OperDate = Movement.OperDate
                                                                           AND Movement_find.DescId   = Movement.DescId
                                                                           AND Movement_find.StatusId = zc_Enum_Status_Complete()
                                       INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                                                     ON MovementLinkObject_From_find.MovementId = Movement_find.Id
                                                                    AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
                                                                    AND MovementLinkObject_From_find.ObjectId = vbFromId
                                       INNER JOIN MovementLinkObject AS MovementLinkObject_Retail_find
                                                                     ON MovementLinkObject_Retail_find.MovementId = Movement_find.Id
                                                                    AND MovementLinkObject_Retail_find.DescId = zc_MovementLinkObject_Retail()
                                                                    AND MovementLinkObject_Retail_find.ObjectId = vbRetailId
                                 UNION
                                  SELECT inMovementId AS MovementId WHERE vbRetailId = 0
                                  ) AS tmp
                            WHERE inisJuridical = FALSE
                           UNION
                            SELECT tmpListDoc.MovementId
                            FROM tmpListDoc
                            WHERE inisJuridical = TRUE
                           )

  , tmpMI_All AS (SELECT MovementItem.Id       AS MovementItemId
                       , MovementItem.ObjectId AS GoodsId
                       , MovementItem.Amount   AS Amount
                  FROM tmpMovement
                       INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                              AND MovementItem.DescId     = zc_MI_Master()
                                              AND MovementItem.isErased   = FALSE
                  )
  , tmpMI_Float AS (SELECT MovementItemFloat.*
                    FROM MovementItemFloat
                    WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_All.MovementItemId FROM tmpMI_All)
                      AND MovementItemFloat.DESCId IN ( zc_MIFloat_Price(), zc_MIFloat_AmountSecond(), zc_MIFloat_CountForPrice(), zc_MIFloat_Summ())
                   )
  , tmpMI_LO AS (SELECT MovementItemLinkObject.*
                 FROM MovementItemLinkObject
                 WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_All.MovementItemId FROM tmpMI_All)
                   AND MovementItemLinkObject.DESCId = zc_MILinkObject_GoodsKind()
                )

  , tmpMI AS (SELECT MAX (tmpMI_All.MovementItemId) AS MovementItemId
                   , tmpMI_All.GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                   , CASE WHEN vbDiscountPercent <> 0
                               THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          WHEN vbExtraChargesPercent <> 0
                               THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          ELSE COALESCE (MIFloat_Price.ValueData, 0)
                     END AS Price
                   , MIFloat_CountForPrice.ValueData AS CountForPrice
                   , SUM (tmpMI_All.Amount) AS Amount
                   , SUM (COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS AmountSecond
                   , SUM (COALESCE (MIFloat_Summ.ValueData, 0)) AS Summ
              FROM tmpMI_All
                   LEFT JOIN tmpMI_Float AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = tmpMI_All.MovementItemId
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   LEFT JOIN tmpMI_Float AS MIFloat_AmountSecond
                                         ON MIFloat_AmountSecond.MovementItemId = tmpMI_All.MovementItemId
                                        AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                   LEFT JOIN tmpMI_Float AS MIFloat_CountForPrice
                                         ON MIFloat_CountForPrice.MovementItemId = tmpMI_All.MovementItemId
                                        AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                   LEFT JOIN tmpMI_Float AS MIFloat_Summ
                                         ON MIFloat_Summ.MovementItemId = tmpMI_All.MovementItemId
                                        AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

                   LEFT JOIN tmpMI_LO AS MILinkObject_GoodsKind
                                      ON MILinkObject_GoodsKind.MovementItemId = tmpMI_All.MovementItemId
                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
              GROUP BY tmpMI_All.GoodsId
                     , MILinkObject_GoodsKind.ObjectId
                     , MIFloat_Price.ValueData
                     , MIFloat_CountForPrice.ValueData
             )
          , tmpMI_Child AS (SELECT MovementItem.ParentId
                                 , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0 THEN MovementItem.Amount ELSE 0 END * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeight
                                 , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0 THEN MovementItem.Amount ELSE 0 END * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeightSecond
                                 , SUM (MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeight_all
                            FROM MovementItem
                                 LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                             ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                            AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()

                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                      ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                     AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                       ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                      AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Child()
                              AND MovementItem.isErased   = FALSE
                            GROUP BY MovementItem.ParentId
                           )

            -- ячейки отбора
          , tmpChoiceCell AS (SELECT gpSelect.NPP           ::Integer   AS NPP
                                   , gpSelect.Code          ::Integer   AS CellCode
                                   , gpSelect.Name          ::TVarChar  AS CellName
                                   , LEFT (gpSelect.Name, 1)::TVarChar  AS CellName_shot
                                   , gpSelect.GoodsId
                                   , gpSelect.GoodsKindId
                                   , ROW_NUMBER() OVER (PARTITION BY gpSelect.GoodsId, gpSelect.GoodsKindId ORDER BY gpSelect.NPP) AS Ord
                              FROM gpSelect_Object_ChoiceCell (FALSE, inSession) AS gpSelect
                             )


       -- Результат
       SELECT
             CASE WHEN vbIsOrderByLine = TRUE THEN row_number() OVER (ORDER BY tmpMI.MovementItemId) ELSE 0 END :: Integer AS LineNum
           , zfFormat_BarCode (zc_BarCodePref_Object(), COALESCE (View_GoodsByGoodsKind.Id, Object_Goods.Id)) AS IdBarCode
           , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData                AS GoodsGroupName
           , Object_Goods.ObjectCode  			AS GoodsCode
           , Object_Goods.ValueData                     AS GoodsName
           , CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END AS GoodsName_two
           , COALESCE (tmpObject_GoodsPropertyValue.CodeSticker, '') :: TVarChar  AS CodeSticker
           , COALESCE (tmpObject_GoodsPropertyValue.GoodsBoxName_short, tmpObject_GoodsPropertyValueGroup_GoodsBoxName_short.GoodsBoxName_short) AS GoodsBoxName_short

           , CAST (CASE WHEN COALESCE (tmpObject_GoodsPropertyValueGroup_BoxCount.BoxCount, tmpObject_GoodsPropertyValue.BoxCount, 0) > 0
                             THEN CAST ((tmpMI.Amount + tmpMI.AmountSecond) / COALESCE (tmpObject_GoodsPropertyValueGroup_BoxCount.BoxCount, tmpObject_GoodsPropertyValue.BoxCount, 0) AS NUMERIC (16, 4))
                        ELSE 0
                   END AS NUMERIC(16,1)) :: TFloat AS AmountBox

           , COALESCE (tmpObject_GoodsPropertyValueGroup_BoxCount.BoxCount, tmpObject_GoodsPropertyValue.BoxCount, 0)     :: TFloat    AS BoxCount
           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName

           , tmpMI.Amount          :: TFloat AS Amount

           , (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                       THEN tmpMI.Amount * CASE WHEN ObjectFloat_Weight.ValueData > 0 THEN ObjectFloat_Weight.ValueData ELSE 1 END
                       ELSE tmpMI.Amount
              END  * (-1)) :: TFloat AS AmountSort --для сортировки по убыванию по весу

           , tmpMI.AmountSecond    :: TFloat AS AmountSecond
           , tmpMI.Price           :: TFloat AS Price
           , tmpMI.CountForPrice   :: TFloat AS CountForPrice

           , CASE WHEN vbPriceWithVAT = FALSE OR vbVATPercent = 0
                       -- если цены без НДС или %НДС = 0
                       THEN tmpMI.AmountSumm
                       -- если цены с НДС
                  ELSE CAST ((tmpMI.Summ / (1 + vbVATPercent / 100)) AS NUMERIC (16, 2))
             END :: TFloat AS SummMVAT

           , tmpMI.Summ :: TFloat AS SummPVAT

           , COALESCE (tmpRemains.Amount, 0)  :: TFloat AS AmountRemains

           , ObjectFloat_WmsCellNum.ValueData  AS WmsCellNum

           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                       THEN tmpMI_Child.AmountWeight_all / CASE WHEN ObjectFloat_Weight.ValueData > 0 THEN ObjectFloat_Weight.ValueData ELSE 1 END
                       ELSE tmpMI_Child.AmountWeight_all
             END :: TFloat AS Amount_child

           , CASE WHEN vbIsRemains = TRUE
                   /*AND COALESCE (tmpMI.Amount, 0) + COALESCE (tmpMI.AmountSecond, 0)
                     > CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                 THEN COALESCE (tmpMI_Child.AmountWeight_all / CASE WHEN ObjectFloat_Weight.ValueData > 0 THEN ObjectFloat_Weight.ValueData ELSE 1 END, 0)
                                 ELSE COALESCE (tmpMI_Child.AmountWeight_all, 0)
                       END*/
                       THEN COALESCE (tmpMI.Amount, 0) + COALESCE (tmpMI.AmountSecond, 0)
                          - CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                      THEN COALESCE (tmpMI_Child.AmountWeight_all / CASE WHEN ObjectFloat_Weight.ValueData > 0 THEN ObjectFloat_Weight.ValueData ELSE 1 END, 0)
                                      ELSE COALESCE (tmpMI_Child.AmountWeight_all, 0)
                            END
                  ELSE 0
             END :: TFloat AS Amount_child_diff

             -- не ошибка, кто-то напутал
           , COALESCE (tmpChoiceCell.CellCode, tmpChoiceCell_two.CellCode)           ::Integer  AS NPP
           , COALESCE (tmpChoiceCell.CellCode, tmpChoiceCell_two.CellCode)           ::Integer  AS CellCode
           , COALESCE (tmpChoiceCell.NPP, tmpChoiceCell_two.NPP)                     ::Integer  AS NPP_NE_nado
           , COALESCE (tmpChoiceCell.CellName, tmpChoiceCell_two.CellName)           ::TVarChar AS CellName
           , COALESCE (tmpChoiceCell.CellName_shot, tmpChoiceCell_two.CellName_shot) ::TVarChar AS CellName_shot
       FROM (SELECT tmpMI.MovementItemId
                  , tmpMI.GoodsId
                  , tmpMI.GoodsKindId
                  , tmpMI.Price
                  , tmpMI.CountForPrice
                  , tmpMI.Amount
                  , tmpMI.AmountSecond
                  , tmpMI.Summ
                  , CAST ((tmpMI.Amount + tmpMI.AmountSecond) * tmpMI.Price / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END AS NUMERIC (16, 2)) AS AmountSumm
             FROM tmpMI

            ) AS tmpMI
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI.MovementItemId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN Object_GoodsByGoodsKind_View AS View_GoodsByGoodsKind ON View_GoodsByGoodsKind.GoodsId = Object_Goods.Id
                                                                           AND View_GoodsByGoodsKind.GoodsKindId = Object_GoodsKind.Id

            LEFT JOIN ObjectFloat AS ObjectFloat_WmsCellNum
                                  ON ObjectFloat_WmsCellNum.ObjectId = View_GoodsByGoodsKind.Id
                                 AND ObjectFloat_WmsCellNum.DescId = zc_ObjectFloat_GoodsByGoodsKind_WmsCellNum()

            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsSub
                                 ON ObjectLink_GoodsByGoodsKind_GoodsSub.ObjectId = View_GoodsByGoodsKind.Id
                                AND ObjectLink_GoodsByGoodsKind_GoodsSub.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsSub()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindSub
                                 ON ObjectLink_GoodsByGoodsKind_GoodsKindSub.ObjectId = View_GoodsByGoodsKind.Id
                                AND ObjectLink_GoodsByGoodsKind_GoodsKindSub.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub()

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId

            /*LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = tmpMI.GoodsId
                                                       AND tmpObject_GoodsPropertyValue.GoodsId IS NULL*/
            LEFT JOIN tmpObject_GoodsPropertyValueGroup_GoodsBoxName_short ON tmpObject_GoodsPropertyValueGroup_GoodsBoxName_short.GoodsId = tmpMI.GoodsId
                                                                          AND COALESCE (tmpObject_GoodsPropertyValue.GoodsBoxName_short, '') = ''
            LEFT JOIN tmpObject_GoodsPropertyValueGroup_BoxCount ON tmpObject_GoodsPropertyValueGroup_BoxCount.GoodsId = tmpMI.GoodsId
                                                                AND COALESCE (tmpObject_GoodsPropertyValue.BoxCount, 0) = 0

            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = tmpMI.GoodsId
                                                        AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = tmpMI.GoodsKindId

            LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                   ON ObjectString_Goods_GroupNameFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                                 ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI.GoodsId
                                AND tmpRemains.GoodsKindId = CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                                                  , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                                                  , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                                                   )
                                                                       THEN tmpMI.GoodsKindId
                                                                  WHEN ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье                                                                                       THEN tmpMI_Goods.GoodsKindId
                                                                       THEN tmpMI.GoodsKindId
                                                                  ELSE 0
                                                             END

            LEFT JOIN tmpChoiceCell ON tmpChoiceCell.GoodsId = tmpMI.GoodsId
                                   AND COALESCE (tmpChoiceCell.GoodsKindId,0) = COALESCE (tmpMI.GoodsKindId,0)
                                   AND tmpChoiceCell.Ord = 1
            LEFT JOIN tmpChoiceCell AS tmpChoiceCell_two
                                    ON tmpChoiceCell_two.GoodsId = ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId
                                   AND COALESCE (tmpChoiceCell_two.GoodsKindId,0) = COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId, 0)
                                   AND tmpChoiceCell_two.Ord = 1
                                   AND tmpChoiceCell.GoodsId IS NULL

       WHERE tmpMI.Amount <> 0 OR tmpMI.AmountSecond <> 0
       -- ORDER BY ObjectString_Goods_GroupNameFull.ValueData, Object_Goods.ValueData, Object_GoodsKind.ValueData
       ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_OrderExternal_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.08.19         * WmsCellNum
 21.01.19         * BoxCount
 25.07.18         * CodeSticker
 27.03.18         * add inIsJuridical
 02.11.14                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderExternal_Print (inMovementId := 388160, inIsJuridical:=False, inSession:= zfCalc_UserAdmin())
