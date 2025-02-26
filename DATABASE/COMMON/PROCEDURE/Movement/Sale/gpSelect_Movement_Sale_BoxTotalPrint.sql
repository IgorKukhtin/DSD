-- Function: gpSelect_Movement_Sale_BoxTotalPrint()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_BoxTotalPrint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_BoxTotalPrint(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE Cursor3 refcursor;

    DECLARE vbOperDate TDateTime;
    DECLARE vbOperDatePartner TDateTime;
    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;

    DECLARE vbPaidKindId Integer;
    DECLARE vbContractId Integer;
            vbToId       Integer;
            vbInvNumberOrder   TVarChar;
            vbInvNumberPartner_Order TVarChar;
            vbOperDate_Order   TDateTime;
            vbMovementId_Order Integer;

    DECLARE vbTotalCount  TFloat;
    DECLARE vbVATPercent TFloat;
    DECLARE vbIsProcess_BranchIn Boolean;
    DECLARE vbIsGoodsCode Boolean;

    DECLARE vbWeighingCount   Integer;
    DECLARE vbStoreKeeperName TVarChar;

    DECLARE vbIsKiev Boolean;

    DECLARE vbCountMI Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!! для Киева + Львов
     vbIsKiev:= EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.ObjectId IN (8411, 3080691) AND MLO.DescId = zc_MovementLinkObject_From());


     -- кол-во Взвешиваний
     vbWeighingCount:= (SELECT COUNT(*)
                        FROM Movement
                        WHERE Movement.ParentId = inMovementId AND Movement.DescId IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                       );

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
     --  zc_MIFloat_BoxCount
     vbTotalCount := (SELECT SUM (COALESCE (MIFloat_BoxCount.ValueData,0))
                      FROM MovementItem
                         INNER JOIN MovementItemFloat AS MIFloat_BoxCount
                                                      ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                                     AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId = zc_MI_Master()
                        AND MovementItem.IsErased = FALSE
                      );

     -- Проверка
     IF EXISTS (SELECT 1
                FROM Movement
                     LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                            ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                           AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Sale()
                  AND COALESCE (MovementDate_OperDatePartner.ValueData, zc_DateStart()) < (Movement.OperDate - INTERVAL '15 DAY')
                  AND (EXTRACT (MONTH FROM Movement.OperDate) = EXTRACT (MONTH FROM CURRENT_DATE)
                    OR EXTRACT (MONTH FROM Movement.OperDate) = EXTRACT (MONTH FROM CURRENT_DATE - INTERVAL '17 DAY')
                      )
               )
     THEN
         RAISE EXCEPTION 'Ошибка.В документе от <%> неверное значение дата у покупателя <%>.', zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                                                                                             , zfConvert_DateToString ((SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_OperDatePartner()));
     END IF;

     -- параметры из документа
     SELECT Movement.OperDate
          , MovementDate_OperDatePartner.ValueData
          , Movement.DescId
          , Movement.StatusId
          , MovementLinkObject_To.ObjectId                            AS ToId
          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0)        AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0)        AS ContractId
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)          AS VATPercent 
         
          , MovementLinkMovement_Order.MovementChildId     AS MovementId_Order
          , Movement_order.OperDate                        AS OperDate_Order
          , MovementString_InvNumberOrder.ValueData        AS InvNumberOrder
          , MovementString_InvNumberPartner_order.ValueData AS InvNumberPartner_Order

            INTO vbOperDate, vbOperDatePartner, vbDescId, vbStatusId , vbToId, vbPaidKindId, vbContractId, vbVATPercent
               , vbMovementId_Order, vbOperDate_Order, vbInvNumberOrder, vbInvNumberPartner_Order
     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindTo())
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                         ON MovementLinkMovement_Order.MovementId = Movement.Id
                                        AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
          LEFT JOIN Movement AS Movement_order ON Movement_order.Id = MovementLinkMovement_Order.MovementChildId  
          
          LEFT JOIN MovementString AS MovementString_InvNumberPartner_order
                                   ON MovementString_InvNumberPartner_order.MovementId = Movement_order.Id
                                  AND MovementString_InvNumberPartner_order.DescId = zc_MovementString_InvNumberPartner()
                                    
          LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                   ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                  AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
     WHERE Movement.Id = inMovementId
    ;


    -- Важный параметр - Прихрд на филиала или расход с филиала (в первом слчае вводится только "Дата (приход)")
    vbIsProcess_BranchIn:= EXISTS (SELECT Id FROM Object_Unit_View WHERE Id = (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_To()) AND BranchId = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId))
                           ;

    -- очень важная проверка
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete() AND inSession <> zfCalc_UserAdmin()
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

     --
    OPEN Cursor1 FOR
--     WITH tmpObject_GoodsPropertyValue AS
       WITH tmpMovementDate AS (SELECT *
                                  FROM MovementDate
                                  WHERE MovementDate.MovementId = inMovementId
                                    AND MovementDate.DescId IN (zc_MovementDate_OperDatePartner()
                                                                 )
                                  )

          , tmpMovementString AS (SELECT *
                                  FROM MovementString
                                  WHERE MovementString.MovementId = inMovementId
                                    AND MovementString.DescId IN (zc_MovementString_InvNumberOrder()
                                                                , zc_MovementString_Comment()
                                                                , zc_MovementString_InvNumberPartner()
                                                                 )
                                  )

          , tmpMovement AS (SELECT * FROM Movement WHERE Movement.Id = inMovementId)

          , tmpMovementFloat AS (SELECT *
                                  FROM MovementFloat
                                  WHERE MovementFloat.MovementId = inMovementId
                                    AND MovementFloat.DescId IN ( zc_MovementFloat_TotalSummTare()
                                                                 )
                                  )
       SELECT
             Movement.Id                                AS Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
           , Movement.InvNumber                         AS InvNumber
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner

           , Movement.OperDate                          AS OperDate
           , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) :: TDateTime AS OperDatePartner 
           , vbMovementId_Order       AS MovementId_Order
           , vbOperDate_Order         AS OperDate_Order
           , vbInvNumberOrder         AS InvNumberOrder 
           , vbInvNumberPartner_Order AS InvNumberPartner_Order
           , 0                              AS VATPercent
           , 0                              AS ChangePercent
           , vbTotalCount                   AS TotalCount
           , 0                              AS TotalCountKg
           , 0                              AS TotalCountSh
           , 0                              AS TotalSummMVAT
           , 0                              AS TotalSummPVAT
           , 0                              AS SummVAT
           , 0                              AS TotalSumm
           , 0                              AS TotalSummMVAT_Info
           --Сумма оборотной тары
           , MovementFloat_TotalSummTare.ValueData AS TotalSummPVAT_Tare -- c НДС
           , CAST (MovementFloat_TotalSummTare.ValueData - MovementFloat_TotalSummTare.ValueData * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 4)) AS TotalSummMVAT_Tare --  без НДС


           , Object_From.ValueData             		AS FromName
           , CASE WHEN vbIsKiev = TRUE THEN TRUE ELSE FALSE END AS isPrintPageBarCode

           , COALESCE (Object_Partner.ValueData, Object_To.ValueData) AS ToName
           , Object_PaidKind.ValueData         		    AS PaidKindName
           , View_Contract.InvNumber        		    AS ContractName
           , ObjectDate_Signing.ValueData               AS ContractSigningDate
           , View_Contract.ContractKindName             AS ContractKind
           , COALESCE (ObjectString_PartnerCode.ValueData, '') :: TVarChar AS PartnerCode

           , CASE WHEN COALESCE (Object_PersonalStore_View.PersonalName, '') <> '' THEN zfConvert_FIO (Object_PersonalStore_View.PersonalName, 2, FALSE) ELSE vbStoreKeeperName END  AS StoreKeeper -- кладовщик
           , '' :: TVarChar                             AS Through     -- через кого
           , CASE WHEN OH_JuridicalDetails_To.OKPO IN ('32516492', '39135315', '39622918') THEN 'м. Київ, вул Ольжича, 18/22' ELSE '' END :: TVarChar  AS UnitAddress -- адреса складання

           , ObjectString_Partner_ShortName.ValueData   AS ShortNamePartner_To
           , ObjectString_ToAddress.ValueData           AS PartnerAddress_To

           , (CASE WHEN ObjectString_PostalCode.ValueData  <> '' THEN ObjectString_PostalCode.ValueData || ' '      ELSE '' END
           || CASE WHEN View_Partner_Address.RegionName    <> '' THEN View_Partner_Address.RegionName   || ' обл., ' ELSE '' END
           || CASE WHEN View_Partner_Address.ProvinceName  <> '' THEN View_Partner_Address.ProvinceName || ' р-н, '  ELSE '' END
           || ObjectString_ToAddress.ValueData
             ) :: TVarChar            AS PartnerAddressAll_To
           , OH_JuridicalDetails_To.JuridicalId         AS JuridicalId_To
           , COALESCE (Object_ArticleLoss.ValueData, OH_JuridicalDetails_To.FullName) AS JuridicalName_To
           , OH_JuridicalDetails_To.JuridicalAddress    AS JuridicalAddress_To

           , OH_JuridicalDetails_From.JuridicalId       AS JuridicalId_From
           , OH_JuridicalDetails_From.FullName          AS JuridicalName_From
           , OH_JuridicalDetails_From.JuridicalAddress  AS JuridicalAddress_From

           , CASE WHEN COALESCE (ObjectString_PlaceOf.ValueData, '') <> '' THEN COALESCE (ObjectString_PlaceOf.ValueData, '')
                  ELSE '' -- 'м.Днiпро'
                  END  :: TVarChar   AS PlaceOf
           , CASE WHEN COALESCE (Object_Personal_View.PersonalName, '') <> '' THEN zfConvert_FIO (Object_Personal_View.PersonalName, 2, FALSE) ELSE '' END AS PersonalBookkeeperName   -- бухгалтер из спр.Филиалы

           , CASE WHEN OH_JuridicalDetails_To.OKPO IN ('02147345') THEN '' ELSE MovementSale_Comment.ValueData END :: TVarChar AS SaleComment
           , CASE WHEN OH_JuridicalDetails_To.OKPO IN ('02147345') THEN MovementSale_Comment.ValueData ELSE '' END :: TVarChar AS SaleComment_02147345

           , '' :: TVarChar AS OrderComment
           , CASE WHEN Position(UPPER('обмен') in UPPER(View_Contract.InvNumber)) > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPrintText

           , CASE WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm() THEN TRUE ELSE FALSE END :: Boolean AS isFirstForm

               -- Мiсце складання
           , 'м.Дніпро' :: TVarChar AS CityOf

           --если мало строк печатается 2 копии
           , CASE WHEN COALESCE (vbCountMI,0) > 3 THEN FALSE ELSE TRUE END AS isTwoCopies

       FROM tmpMovement AS Movement

            LEFT JOIN tmpMovementString AS MovementSale_Comment
                                        ON MovementSale_Comment.MovementId = Movement.Id
                                       AND MovementSale_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                      ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                        ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                       AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                AND vbContractId = 0

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_From.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN ObjectString AS ObjectString_PlaceOf
                                   ON ObjectString_PlaceOf.ObjectId = COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
                                  AND ObjectString_PlaceOf.DescId = zc_objectString_Branch_PlaceOf()
            LEFT JOIN ObjectLink AS ObjectLink_Branch_Personal
                                 ON ObjectLink_Branch_Personal.ObjectId = ObjectLink_Unit_Branch.ChildObjectId
                                AND ObjectLink_Branch_Personal.DescId = zc_ObjectLink_Branch_Personal()
            LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Branch_Personal.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalStore
                                 ON ObjectLink_Branch_PersonalStore.ObjectId = ObjectLink_Unit_Branch.ChildObjectId
                                AND ObjectLink_Branch_PersonalStore.DescId = zc_ObjectLink_Branch_PersonalStore()
            LEFT JOIN Object_Personal_View AS Object_PersonalStore_View ON Object_PersonalStore_View.PersonalId = ObjectLink_Branch_PersonalStore.ChildObjectId

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummTare
                                       ON MovementFloat_TotalSummTare.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSummTare.DescId = zc_MovementFloat_TotalSummTare()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                         ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                        AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
            LEFT JOIN Object AS Object_ArticleLoss ON Object_ArticleLoss.Id = MovementLinkObject_ArticleLoss.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN ObjectString AS ObjectString_ToAddress
                                   ON ObjectString_ToAddress.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_ToAddress.DescId = zc_ObjectString_Partner_Address()
            LEFT JOIN ObjectString AS ObjectString_Partner_ShortName
                                   ON ObjectString_Partner_ShortName.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_Partner_ShortName.DescId = zc_ObjectString_Partner_ShortName()
            LEFT JOIN Object_Partner_Address_View AS View_Partner_Address ON View_Partner_Address.PartnerId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
            LEFT JOIN ObjectString AS ObjectString_PostalCode
                                   ON ObjectString_PostalCode.ObjectId = View_Partner_Address.StreetId
                                  AND ObjectString_PostalCode.DescId = zc_ObjectString_Street_PostalCode()

            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = vbPaidKindId -- MovementLinkObject_PaidKind.ObjectId
-- Contract
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = vbContractId -- MovementLinkObject_Contract.ObjectId
            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = View_Contract.ContractId -- MovementLinkObject_Contract.ObjectId
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                AND View_Contract.InvNumber <> '-'
            LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                                 ON ObjectLink_Contract_JuridicalDocument.ObjectId = View_Contract.ContractId -- MovementLinkObject_Contract.ObjectId
                                AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
                                AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()
            -- код поставщика
            LEFT JOIN ObjectString AS ObjectString_PartnerCode
                                   ON ObjectString_PartnerCode.ObjectId = View_Contract.ContractId
                                  AND ObjectString_PartnerCode.DescId = zc_objectString_Contract_PartnerCode()

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                ON OH_JuridicalDetails_To.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_To.Id)
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = COALESCE (ObjectLink_Contract_JuridicalDocument.ChildObjectId
                                                                                                        , COALESCE (View_Contract.JuridicalBasisId
                                                                                                        , COALESCE (ObjectLink_Unit_Juridical.ChildObjectId
                                                                                                                  , Object_From.Id)))
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_From.EndDate
       WHERE Movement.Id =  inMovementId
         AND Movement.StatusId = zc_Enum_Status_Complete()
      ;
    RETURN NEXT Cursor1;

    -- печать гофро тары
    OPEN Cursor2 FOR
      WITH
      -- товары из группы Гофротара  -- 1960
      tmpGoods AS (SELECT lfSelect.GoodsId AS GoodsId
                   FROM lfSelect_Object_Goods_byGoodsGroup (1960) AS lfSelect
                   )
    , tmpMI AS (SELECT tmp.GoodsId
                     , SUM (COALESCE (tmp.AmountPartner,0)) AS AmountPartner
                FROM (SELECT MILinkObject_Box.ObjectId                     AS GoodsId
                           , SUM (COALESCE (MIFloat_BoxCount.ValueData,0)) AS AmountPartner
                      FROM MovementItem
                          INNER JOIN MovementItemLinkObject AS MILinkObject_Box
                                                            ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Box.DescId = zc_MILinkObject_Box()
                          LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                                      ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                                     AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                       GROUP BY MILinkObject_Box.ObjectId
                     UNION
                      SELECT MovementItem.ObjectId AS GoodsId
                           , SUM (COALESCE (MovementItem.Amount,0)) AS AmountPartner
                      FROM MovementItem
                           INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                       GROUP BY MovementItem.ObjectId
                      ) AS tmp
                GROUP BY tmp.GoodsId
               )
     --выбираем данные из др. документов  Movement.OperDate - 1 по Movement.OperDate + 1
     , tmpMI_ets AS (WITH
                     tmpMovement AS (SELECT Movement.Id
                                     FROM Movement
                                         INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                      AND MovementLinkObject_To.ObjectId = vbToId
                                         INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                      AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
                                                                      AND MovementLinkObject_Contract.ObjectId = vbContractId
                                         LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                                                  ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                                                 AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder() 
                                     WHERE Movement.DescId = zc_Movement_Sale()
                                       AND Movement.OperDate >= vbOperDate - INTERVAL '1 day'
                                       AND Movement.OperDate <= vbOperDate + INTERVAL '1 day'
                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                       AND COALESCE (MovementString_InvNumberOrder.ValueData,'') = COALESCE (vbInvNumberOrder,'')
                                       AND Movement.Id <> inMovementId
                                     )
                   , tmpMI AS (SELECT *
                               FROM MovementItem
                               WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
                               )
                     SELECT tmp.GoodsId
                          , SUM (COALESCE (tmp.AmountPartner,0)) AS AmountPartner
                     FROM (SELECT MILinkObject_Box.ObjectId                AS GoodsId
                                , SUM (COALESCE (MIFloat_BoxCount.ValueData,0)) AS AmountPartner
                           FROM tmpMI AS MovementItem
                               INNER JOIN MovementItemLinkObject AS MILinkObject_Box
                                                                 ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Box.DescId = zc_MILinkObject_Box()
                               INNER JOIN MovementItemFloat AS MIFloat_BoxCount
                                                            ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                                           AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
                           GROUP BY MILinkObject_Box.ObjectId
                         UNION
                           SELECT MovementItem.ObjectId AS GoodsId
                                , SUM (COALESCE (MovementItem.Amount,0)) AS AmountPartner
                           FROM tmpMI AS MovementItem
                                INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                           GROUP BY MovementItem.ObjectId
                          ) AS tmp
                     GROUP BY tmp.GoodsId
                     )

      SELECT Object_Goods.ObjectCode         AS GoodsCode
           , Object_Goods.ValueData          AS GoodsName_two
           , Object_Measure.ValueData        AS MeasureName

           , tmpMI.AmountPartner             AS AmountPartner
           , CAST (tmpMI.AmountPartner * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 0 END ) AS TFloat) AS Amount_Weight
           , CAST (tmpMI.AmountPartner * COALESCE (ObjectFloat_Weight.ValueData, 0) AS TFloat) AS AmountPack_Weight

           , 0 ::TFloat AS PriceWVAT
           , 0 ::TFloat AS AmountSumm

      FROM tmpMI
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                 ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

     UNION ALL
      SELECT Object_Goods.ObjectCode         AS GoodsCode
           , Object_Goods.ValueData          AS GoodsName_two
           , Object_Measure.ValueData        AS MeasureName

           , tmpMI_ets.AmountPartner             AS AmountPartner
           , CAST (tmpMI_ets.AmountPartner * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 0 END ) AS TFloat) AS Amount_Weight
           , CAST (tmpMI_ets.AmountPartner * COALESCE (ObjectFloat_Weight.ValueData, 0) AS TFloat) AS AmountPack_Weight

           , 0 ::TFloat AS PriceWVAT
           , 0 ::TFloat AS AmountSumm

      FROM tmpMI_ets
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_ets.GoodsId

           LEFT JOIN tmpMI ON tmpMI.GoodsId = tmpMI_ets.GoodsId

           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                 ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

      WHERE tmpMI.GoodsId IS NULL
      ORDER BY 2
     ;

    RETURN NEXT Cursor2;

   /* OPEN Cursor3 FOR
      WITH tmpMI AS (SELECT MovementItem.ObjectId                         AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                          , SUM (MovementItem.Amount) AS Amount
                          , SUM (MovementItem.Amount) AS AmountPartner
                     FROM MovementItem
                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                          --если MIFloat_Price.ValueData = 0, тогда берем zc_MIFloat_PriceTare
                          LEFT JOIN MovementItemFloat AS MIFloat_PriceTare
                                                      ON MIFloat_PriceTare.MovementItemId = MovementItem.Id
                                                     AND MIFloat_PriceTare.DescId = zc_MIFloat_PriceTare()
                                                     AND COALESCE (MIFloat_Price.ValueData,0) = 0
                          LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                      ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                     AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                          LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                     -- !!!временно отключил!!!
                     WHERE MovementItem.MovementId = NULL -- inMovementId

                       AND MovementItem.DescId     = zc_MI_Master()
                       AND MovementItem.isErased   = FALSE
                       ---- AND COALESCE (MIFloat_Price.ValueData, 0) = 0
                       --AND COALESCE (MIFloat_PriceTare.ValueData,0) <> 0
                       AND 1 = 0 -- !!!временно отключил!!!
                     GROUP BY MovementItem.ObjectId
                            , MILinkObject_GoodsKind.ObjectId
                    )
      SELECT Object_Goods.ObjectCode         AS GoodsCode
           , (Object_Goods.ValueData || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END) :: TVarChar AS GoodsName
           , Object_Goods.ValueData          AS GoodsName_two
           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName

           , tmpMI.Amount                    AS Amount
           , tmpMI.AmountPartner             AS AmountPartner
           , CAST ((tmpMI.AmountPartner * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 0 END )) AS TFloat) AS Amount_Weight
           -- , CAST ((CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpMI.AmountPartner ELSE 0 END) AS TFloat) AS Amount_Sh

       FROM tmpMI

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

      ;

    RETURN NEXT Cursor3;
    */
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.02.25        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Sale_BoxTotalPrint (inMovementId:= 18441615, inSession:= zfCalc_UserAdmin()); -- FETCH ALL "<unnamed portal 1>";
