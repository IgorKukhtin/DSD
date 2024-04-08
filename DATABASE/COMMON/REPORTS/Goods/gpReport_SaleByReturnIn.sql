-- Function: gpReport_SaleByReturnIn ()

DROP FUNCTION IF EXISTS gpReport_SaleByTransferDebtIn (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Tfloat, TVarChar);
DROP FUNCTION IF EXISTS gpReport_SaleByReturnIn (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Tfloat, TVarChar);
DROP FUNCTION IF EXISTS gpReport_SaleByReturnIn (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Tfloat, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SaleByReturnIn (
    IN inStartDate         TDateTime ,
    IN inEndDate           TDateTime ,
    IN inPartnerId         Integer   ,
    IN inJuridicalId       Integer   ,
    IN inRetailId          Integer   ,
    IN inBranchId          Integer   ,
    IN inContractId        Integer   ,
    IN inPaidKindId        Integer   ,
    IN inGoodsId           Integer   ,
    IN inGoodsKindId       Integer   , --
    IN inPrice             Tfloat    , --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , RetailName TVarChar
             , PaidKindId TVarChar, PaidKindName TVarChar
             , BranchName TVarChar, UnitName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar

             , Amount        TFloat  -- 
             , AmountReturn  TFloat  -- 
             , AmountRem     TFloat  -- 
             , Price         TFloat  -- 
             
             , InvNumber TVarChar, InvNumberPartner TVarChar, OperDate TDateTime, OperDatePartner TDateTime
             , InvNumber_Master TVarChar, InvNumberPartner_Master TVarChar, OperDate_Master TDateTime
             , DocumentTaxKindName TVarChar
             , MovementId Integer, MovementItemId Integer
             , MovementDescName TVarChar
             ) 

AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    CREATE TEMP TABLE _tmpListPartner (PartnerId Integer, JuridicalId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpListUnit (UnitId Integer) ON COMMIT DROP;

    -- Ограничения 
    IF inPartnerId <> 0
    THEN
        INSERT INTO _tmpListPartner (PartnerId, JuridicalId)
            SELECT ObjectLink_Jur.ObjectId AS PartnerId, ObjectLink_Jur.ChildObjectId AS JuridicalId
            FROM ObjectLink AS ObjectLink_Jur
            WHERE ObjectLink_Jur.ObjectId = inPartnerId
              AND ObjectLink_Jur.DescId   = zc_ObjectLink_Partner_Juridical()
           ;
        /*INSERT INTO _tmpListPartner (PartnerId, JuridicalId)
            SELECT ObjectLink_Jur.ObjectId AS PartnerId, ObjectLink_Jur.ChildObjectId AS JuridicalId
            FROM ObjectLink AS ObjectLink_Jur
            WHERE ObjectLink_Jur.ChildObjectId = (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = inPartnerId AND ObjectLink.DescId = zc_ObjectLink_Partner_Juridical())
              AND ObjectLink_Jur.DescId        = zc_ObjectLink_Partner_Juridical()
          ;*/
    ELSE 
        IF inJuridicalId <> 0
        THEN
            INSERT INTO _tmpListPartner (PartnerId, JuridicalId)
               SELECT OL_Partner_Juridical.ObjectId AS PartnerId
                    , OL_Partner_Juridical.ChildObjectId AS JuridicalId
               FROM ObjectLink AS OL_Partner_Juridical
               WHERE OL_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                 AND OL_Partner_Juridical.ChildObjectId = inJuridicalId --250209
           ;
        ELSE 
            IF inRetailId <> 0 THEN
               INSERT INTO _tmpListPartner (PartnerId, JuridicalId)
                  SELECT  ObjectLink_Partner_Juridical.ObjectId 
                        , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                  FROM ObjectLink AS ObjectLink_Juridical_Retail 
                     LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                          ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                  WHERE ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                    AND ObjectLink_Juridical_Retail.ChildObjectId = inRetailId --310842 
                 ;
            ELSE 
                RAISE EXCEPTION 'Ошибка.Не установлено значение <Точка доставки>.';
            END IF;
        END IF;
    END IF;
    

IF inBranchId <> 0
    THEN
        INSERT INTO _tmpListUnit (UnitId)
           SELECT ObjectLink_Unit_Branch.ObjectId      AS UnitId
           FROM ObjectLink AS ObjectLink_Unit_Branch
           WHERE ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
             AND ObjectLink_Unit_Branch.ChildObjectId = inBranchId
          ;
    /*ELSE 
            INSERT INTO _tmpListUnit (UnitId, BranchId)
               SELECT Object_Unit.Id      AS UnitId
                    , COALESCE(ObjectLink_Unit_Branch.ChildObjectId,0) AS BranchId
               FROM Object AS Object_Unit
                   LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                        ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                       AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
               WHERE Object_Unit.DescId = zc_Object_Unit()
           ;*/
    END IF;



    -- оптимизация
    ANALYZE _tmpListPartner;
    ANALYZE _tmpListUnit;


    -- Результат
    RETURN QUERY
    WITH tmpContainer_All AS (
              -- Продажа покупателю
              SELECT MovementItem.MovementId
                   , MovementItem.Id                      AS MovementItemId
                   , MD_OperDatePartner.ValueData         AS OperDatePartner
                   , MovementLinkObject_To.ObjectId       AS PartnerId
                   , MovementLinkObject_From.ObjectId     AS UnitId
                   , MLO_PaidKind.ObjectId                AS PaidKindId
                   , MLO_Contract.ObjectId                AS ContractId 
                   , MovementItem.ObjectId                AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId       
            
                   , MIFloat_AmountPartner.ValueData      AS Amount
                   , MIFloat_Price.ValueData              AS Price
          
               FROM MovementDate AS MD_OperDatePartner
                    INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = MD_OperDatePartner.MovementId
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                 AND MovementLinkObject_To.ObjectId IN (SELECT _tmpListPartner.PartnerId FROM _tmpListPartner)
                    -- INNER JOIN _tmpListPartner ON _tmpListPartner.PartnerId = MovementLinkObject_To.ObjectId
                    INNER JOIN Movement ON Movement.Id       = MD_OperDatePartner.MovementId
                                       AND Movement.DescId   = zc_Movement_Sale()
                                       AND Movement.StatusId = zc_Enum_Status_Complete()
 
                    INNER JOIN MovementLinkObject AS MLO_PaidKind
                                                  ON MLO_PaidKind.MovementId = MD_OperDatePartner.MovementId
                                                 AND MLO_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()
                                                 AND MLO_PaidKind.ObjectId   = inPaidKindId
                    LEFT JOIN MovementLinkObject AS MLO_Contract
                                                 ON MLO_Contract.MovementId = MD_OperDatePartner.MovementId
                                                AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
 
                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                 ON MovementLinkObject_From.MovementId = MD_OperDatePartner.MovementId
                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
 
                    INNER JOIN MovementItem ON MovementItem.MovementId = MD_OperDatePartner.MovementId
                                           AND MovementItem.isErased    = FALSE
                                           AND MovementItem.DescId      = zc_MI_Master()
                                           AND MovementItem.ObjectId    = inGoodsId
                    INNER JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                 ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                                                AND MIFloat_AmountPartner.ValueData    <> 0
 
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                    LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                ON MIFloat_Price.MovementItemId = MovementItem.Id
                                               AND MIFloat_Price.DescId         = zc_MIFloat_Price()
              WHERE MD_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate - INTERVAL '1 DAY'
                AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

             UNION ALL
              -- Перевод долга (расход)
              SELECT MovementItem.MovementId
                   , MovementItem.Id                      AS MovementItemId
                   , Movement.OperDate                    AS OperDatePartner
                   , MovementLinkObject_Partner.ObjectId  AS PartnerId
                   , MovementLinkObject_From.ObjectId     AS UnitId
                   , MLO_PaidKind.ObjectId                AS PaidKindId
                   , MLO_Contract.ObjectId                AS ContractId 
                   , MovementItem.ObjectId                AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId       
            
                   , MovementItem.Amount                  AS Amount
                   , MIFloat_Price.ValueData              AS Price
          
               FROM Movement
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                          ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                                         AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                                                         AND MovementLinkObject_Partner.ObjectId IN (SELECT _tmpListPartner.PartnerId FROM _tmpListPartner)
                                            -- INNER JOIN _tmpListPartner ON _tmpListPartner.PartnerId = MovementLinkObject_To.ObjectId

                                            INNER JOIN MovementLinkObject AS MLO_PaidKind
                                                                          ON MLO_PaidKind.MovementId = Movement.Id
                                                                         AND MLO_PaidKind.DescId     = zc_MovementLinkObject_PaidKindTo()
                                                                         AND MLO_PaidKind.ObjectId   = inPaidKindId
                                            LEFT JOIN MovementLinkObject AS MLO_Contract
                                                                         ON MLO_Contract.MovementId = Movement.Id
                                                                        AND MLO_Contract.DescId     = zc_MovementLinkObject_ContractTo()

                                            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_PartnerFrom()

                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.isErased    = FALSE
                                                                   AND MovementItem.DescId      = zc_MI_Master()
                                                                   AND MovementItem.ObjectId    = inGoodsId
                                                                   AND MovementItem.Amount      <> 0

                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_Price.DescId         = zc_MIFloat_Price()
              WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate - INTERVAL '1 DAY'
                AND Movement.DescId = zc_Movement_TransferDebtOut()
                AND Movement.StatusId = zc_Enum_Status_Complete()
                )
  , tmpContainer AS (SELECT tmpContainer_All.*
                     FROM tmpContainer_All
                          LEFT JOIN _tmpListUnit ON _tmpListUnit.UnitId = tmpContainer_All.UnitId
                     WHERE (tmpContainer_All.GoodsKindId = inGoodsKindId OR inGoodsKindId = 0)
                       AND (tmpContainer_All.Price       = inPrice       OR inPrice       = 0)
                       AND (_tmpListUnit.UnitId          > 0             OR inBranchId  = 0)
                       AND (tmpContainer_All.ContractId  = inContractId  OR inContractId = 0)
                    )
  , tmpMI AS (SELECT DISTINCT tmpContainer.MovementItemId FROM tmpContainer)
                        
  , tmpReturnAmount AS (SELECT tmpMI.MovementItemId 
                             , SUM (MI_Child.Amount) AS Amount
                        FROM tmpMI
                             INNER JOIN MovementItemFloat AS MIFloat_MovementItem 
                                                          ON MIFloat_MovementItem.ValueData = tmpMI.MovementItemId
                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                             INNER JOIN MovementItem AS MI_Child ON MI_Child.Id = MIFloat_MovementItem.MovementItemId
                                                                AND MI_Child.isErased = FALSE
                                                               -- AND MI_Child.DescId = zc_MI_Child()
                             INNER JOIN Movement ON Movement.Id       = MI_Child.MovementId
                                                AND Movement.DescId  IN (zc_Movement_ReturnIn(), zc_Movement_PriceCorrective(), zc_Movement_TransferDebtIn())
                                                AND Movement.StatusId = zc_Enum_Status_Complete()
                        GROUP BY tmpMI.MovementItemId
                       )

                                             
    SELECT Object_Goods.Id                            AS GoodsId
         , Object_Goods.ObjectCode                    AS GoodsCode
         , Object_Goods.ValueData                     AS GoodsName
         , Object_GoodsKind.Id                        AS GoodsKindId
         , Object_GoodsKind.ValueData                 AS GoodsKindName
        
         , Object_Juridical.ObjectCode AS JuridicalCode
         , Object_Juridical.ValueData  AS JuridicalName

         , Object_Partner.Id            AS PartnerId
         , Object_Partner.ObjectCode    AS PartnerCode
         , Object_Partner.ValueData     AS PartnerName

          , Object_Retail.ValueData     AS RetailName

         , Object_PaidKind.Id :: TVarChar AS PaidKindId
         , Object_PaidKind.ValueData      AS PaidKindName

         , Object_Branch.ValueData        AS BranchName
         , Object_Unit.ValueData          AS UnitName

         , View_Contract_InvNumber.ContractId      AS ContractId
         , View_Contract_InvNumber.ContractCode    AS ContractCode
         , View_Contract_InvNumber.InvNumber       AS ContractName
         
         , tmpContainer.Amount   ::tfloat 
        --, (select count(*) from tmpContainer) ::tfloat  as Amount 
         , COALESCE(tmpReturnAmount.Amount,0)                         ::tfloat AmountReturn
         , (tmpContainer.Amount - COALESCE(tmpReturnAmount.Amount,0)) ::tfloat AS AmountRem  
         , tmpContainer.Price    ::tfloat
         

         , Movement_Sale.InvNumber
         , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner
         , Movement_Sale.Operdate
         , tmpContainer.OperDatePartner
         
         , Movement_DocumentMaster.InvNumber        AS InvNumber_Master
         , MS_InvNumberPartner_Master.ValueData     AS InvNumberPartner_Master
         , Movement_DocumentMaster.OperDate         AS OperDate_Master
         , Object_TaxKind_Master.ValueData     	    AS DocumentTaxKindName

         , tmpContainer.MovementId
         , tmpContainer.MovementItemId
                    
         , MovementDesc.ItemName AS MovementDescName

       FROM tmpContainer
          LEFT JOIN tmpReturnAmount ON tmpReturnAmount.MovementItemId = tmpContainer.MovementItemId

          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpContainer.PartnerId
          LEFT JOIN _tmpListPartner ON _tmpListPartner.PartnerId = Object_Partner.Id
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = _tmpListPartner.JuridicalId
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpContainer.PaidKindId
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpContainer.UnitId
          LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpContainer.ContractId
           
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpContainer.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpContainer.GoodsKindId
          
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                               ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                              AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId


          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

          LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = tmpContainer.MovementId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement_Sale.DescId

          LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                   ON MovementString_InvNumberPartner.MovementId = Movement_Sale.Id 
                                  AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                           ON MovementLinkMovement_Master.MovementId = Movement_Sale.Id
                                          AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
          LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementChildId
          LEFT JOIN MovementString AS MS_InvNumberPartner_Master
                                   ON MS_InvNumberPartner_Master.MovementId = MovementLinkMovement_Master.MovementChildId
                                  AND MS_InvNumberPartner_Master.DescId = zc_MovementString_InvNumberPartner()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind_Master
                                       ON MovementLinkObject_DocumentTaxKind_Master.MovementId = Movement_DocumentMaster.Id 
                                      AND MovementLinkObject_DocumentTaxKind_Master.DescId = zc_MovementLinkObject_DocumentTaxKind()
          LEFT JOIN Object AS Object_TaxKind_Master ON Object_TaxKind_Master.Id = MovementLinkObject_DocumentTaxKind_Master.ObjectId
                                                   AND Movement_DocumentMaster.StatusId = zc_Enum_Status_Complete() 
         ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.05.15         * 
*/

-- тест
-- SELECT * FROM gpReport_SaleByReturnIn (inStartDate:= '04.11.2015'::TDateTime, inEndDate:= '04.11.2015'::TDateTime,  inPartnerId:= 112464, inJuridicalId:=0, inRetailId:=0, inBranchId:=0, inContractId:= 0, inPaidKindId:= 0, inGoodsId:= 2507, inGoodsKindId:= 0, inPrice:= 0 :: Tfloat, inSession:= zfCalc_UserAdmin()); -- 
-- SELECT * FROM gpReport_SaleByReturnIn(inStartDate := ('01.01.2016')::TDateTime , inEndDate := ('10.05.2016')::TDateTime , inPartnerId := 17784 , inJuridicalId := 0 , inRetailId := 0 , inBranchId := 0 , inContractId := 16591 , inPaidKindId := 3 , inGoodsId := 2156 , inGoodsKindId := 8328 , inPrice := 127.25 ,  inSession := '5');
