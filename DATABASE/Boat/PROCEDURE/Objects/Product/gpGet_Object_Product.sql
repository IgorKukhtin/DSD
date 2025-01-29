-- Function: gpGet_Object_Product()

DROP FUNCTION IF EXISTS gpGet_Object_Product(Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_Product(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Product(
    IN inId                      Integer,       -- �������� ��������
    iN inMovementId_OrderClient  Integer,
    IN inSession                 TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Hours TFloat, DiscountTax TFloat, DiscountNextTax TFloat
             , SummReal TFloat, SummTax TFloat
             , DateStart TDateTime, DateBegin TDateTime, DateSale TDateTime
             , CIN TVarChar, EngineNum TVarChar
             , Comment TVarChar
             , BrandId Integer, BrandName TVarChar
             , ModelId Integer, ModelName TVarChar, ModelName_full TVarChar
             , EngineId Integer, EngineName TVarChar
             , ReceiptProdModelId Integer, ReceiptProdModelName TVarChar
             , ClientId Integer, ClientName TVarChar     --25    
             , TaxKindId_Client Integer, TaxKindName_Client TVarChar
             , MovementId_OrderClient Integer
             , OperDate_OrderClient  TDateTime
             , InvNumber_OrderClient TVarChar
             , InvNumber_OrderClient_load TVarChar
             , StatusCode_OrderClient Integer
             , StatusName_OrderClient TVarChar
             , VATPercent_OrderClient TFloat
             , NPP_OrderClient TFloat      --33
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSummVAT TFloat     
             
             , OperPrice_load       TFloat
             , TransportSumm_load   TFloat 
             , TransportSumm        TFloat 
             , SummDiscount_total TFloat
             , Basis_summ TFloat, Basis_summ_orig TFloat, Basis_summ1_orig TFloat, Basis_summ2_orig TFloat
             , isBasicConf Boolean, isReserve Boolean, isProdColorPattern Boolean   --40

             , MovementId_Invoice Integer
             , OperDate_Invoice   TDateTime
             , InvNumber_Invoice  TVarChar
             , StatusCode_Invoice Integer
             , StatusName_Invoice TVarChar  
             , MovementId_BankAccount Integer
             , InvNumber_BankAccount  TVarChar
             , OperDate_BankAccount   TDateTime
             , BankAccountId Integer, BankAccountName TVarChar
             , AmountIn_Invoice TFloat
             , AmountIn_InvoiceAll TFloat
             , AmountIn_BankAccount TFloat
             , AmountIn_BankAccountAll TFloat
             , AmountIn_BankAccountLast TFloat
             , AmountIn_rem  TFloat
             , AmountIn_remAll  TFloat   
             -- ������ ��� �������������
             , t1 integer, t2 integer, t3 integer, t4 integer, t5 integer, t6 integer, t7 integer, t8 Integer
              ) AS
$BODY$
    DECLARE vbNPP TFloat;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Product());


   IF COALESCE (inId, 0) = 0
   THEN
   --������� ��������� ����� �� ����������� ������
   vbNPP := COALESCE ((SELECT MAX(MovementFloat.ValueData)
                       FROM MovementFloat
                           INNER JOIN Movement ON Movement.Id = MovementFloat.MovementId
                                              AND Movement.DescId = zc_Movement_OrderClient()
                                              AND Movement.StatusId <> zc_Enum_Status_Erased()
                       WHERE MovementFloat.DescId = zc_MovementFloat_NPP()
                         AND COALESCE (MovementFloat.ValueData,0)<>0
                       ), 0);

       RETURN QUERY
       SELECT
             CAST (0 as Integer)       AS Id
           , lfGet_ObjectCode(0, zc_Object_Product())   AS Code
           , CAST ('' as TVarChar)     AS Name

           , CAST (0 AS TFloat)        AS Hours
           , CAST (0 AS TFloat)        AS DiscountTax
           , CAST (0 AS TFloat)        AS DiscountNextTax
           , CAST (0 AS TFloat)        AS SummReal
           , CAST (0 AS TFloat)        AS SummTax
           , CAST (NULL AS TDateTime)  AS DateStart
           , CAST (NULL AS TDateTime)  AS DateBegin
           , CAST (NULL AS TDateTime)  AS DateSale
           , CAST ('' AS TVarChar)     AS CIN
           , CAST ('' AS TVarChar)     AS EngineNum
           , CAST ('' AS TVarChar)     AS Comment                --14

          -- , CAST (0 AS Integer)    AS ProdGroupId
          -- , CAST ('' AS TVarChar)  AS ProdGroupName
           , CAST (0 AS Integer)       AS BrandId
           , CAST ('' AS TVarChar)     AS BrandName
           , CAST (0 AS Integer)       AS ModelId
           , CAST ('' AS TVarChar)     AS ModelName
           , CAST ('' AS TVarChar)     AS ModelName_full
           , CAST (0 AS Integer)       AS EngineId
           , CAST ('' AS TVarChar)     AS EngineName
           , CAST (0 AS Integer)       AS ReceiptProdModelId
           , CAST ('' AS TVarChar)     AS ReceiptProdModelName
           , CAST (0 AS Integer)       AS ClientId
           , CAST ('' AS TVarChar)     AS ClientName             --25
           , CAST (0 AS Integer)       AS TaxKindId_Client
           , CAST ('' AS TVarChar)     AS TaxKindName_Client     --27
           
           , CAST (0 AS Integer)       AS MovementId_OrderClient
           , CAST (CURRENT_DATE AS TDateTime)  AS OperDate_OrderClient
           , CAST (NEXTVAL ('movement_OrderClient_seq') AS TVarChar) AS InvNumber_OrderClient
           , CAST ('' AS TVarChar)     AS InvNumber_OrderClient_load
           , Object_Status.Code        AS StatusCode_OrderClient
           , Object_Status.Name        AS StatusName_OrderClient
           , CAST (0 AS TFloat)        AS VATPercent_OrderClient
           , (vbNPP +1)       ::TFloat AS NPP_OrderClient

           , CAST (0 AS TFloat)        AS TotalSummMVAT
           , CAST (0 AS TFloat)        AS TotalSummPVAT
           , CAST (0 AS TFloat)        AS TotalSummVAT
           , CAST (0 AS TFloat)        AS OperPrice_load
           , CAST (0 AS TFloat)        AS TransportSumm_load
           , CAST (0 AS TFloat)        AS TransportSumm  
           , CAST (0 AS TFloat)        AS SummDiscount_total 
           , CAST (0 AS TFloat)        AS Basis_summ
           , CAST (0 AS TFloat)        AS Basis_summ_orig
           , CAST (0 AS TFloat)        AS Basis_summ1_orig
           , CAST (0 AS TFloat)        AS Basis_summ2_orig

           , CAST (TRUE AS Boolean)    AS isBasicConf
           , CAST (FALSE AS Boolean)   AS isReserve
           , CAST (TRUE AS Boolean)    AS isProdColorPattern

           , CAST (0 AS Integer)       AS MovementId_Invoice --43
           , CAST (NULL AS TDateTime)  AS OperDate_Invoice
           , CAST ('' AS TVarChar)     AS InvNumber_Invoice
           , Object_Status.Code        AS StatusCode_Invoice
           , Object_Status.Name        AS StatusName_Invoice   
              
           , CAST (0 AS Integer)       AS MovementId_BankAccount
           , CAST ('' AS TVarChar)     AS InvNumber_BankAccount
           , CAST (NULL AS TDateTime)  AS OperDate_BankAccount
           , CAST (0 AS Integer)       AS BankAccountId   --
           , CAST ('' AS TVarChar)     AS BankAccountName
                      , CAST (0 AS TFloat)        AS AmountIn_Invoice
           , CAST (0 AS TFloat)        AS AmountIn_InvoiceAll

           , CAST (0 AS TFloat)        AS AmountIn_BankAccount
           , CAST (0 AS TFloat)        AS AmountIn_BankAccountAll
           , CAST (0 AS TFloat)        AS AmountIn_BankAccountLast

           , CAST (0 AS TFloat)        AS AmountIn_rem
           , CAST (0 AS TFloat)        AS AmountIn_remAll

           --  ��� �������� ��������� ������� �������� � ���������
           , CAST (0 AS Integer) ::integer AS t1
           , CAST (0 AS Integer) ::integer AS t2
           , CAST (0 AS Integer) ::integer AS t3
           , CAST (0 AS Integer) ::integer AS t4
           , CAST (0 AS Integer) ::integer AS t5
           , CAST (0 AS Integer) ::integer AS t6
           , CAST (0 AS Integer) ::integer AS t7
           , CAST (0 AS Integer) ::Integer AS t8

       FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
       ;
   ELSE
     RETURN QUERY
     WITH
     tmpOrderClient AS (
                        SELECT spSelect.FromId             AS ClientId
                             , spSelect.FromName           AS ClientName
                             , spSelect.StatusId
                             , spSelect.StatusCode
                             , spSelect.StatusName
                             , spSelect.InvNumber ::TVarChar
                             , spSelect.OperDate  ::TDateTime
                             , spSelect.Id                              AS MovementId
                             , spSelect.DiscountTax                     AS DiscountTax
                             , spSelect.DiscountNextTax                 AS DiscountNextTax
                             , spSelect.SummDiscount_total              AS SummDiscount_total
                             , spSelect.VATPercent                      AS VATPercent   
                             , spSelect.TaxKindId                       AS TaxKindId
                             , spSelect.TaxKindName                     AS TaxKindName
                               -- ����� ��� ������, ���� ������� ������� ������ �����, ��� ���
                             , spSelect.Basis_summ1_orig
                               -- ����� ��� ������, ����� �����, ��� ���
                             , spSelect.Basis_summ2_orig
                               -- ����� ��� ������, ���� ������� ������� ������ ����� + ����� ���� �����, ��� ���
                             , spSelect.Basis_summ_orig
                               --
                             , spSelect.TransportSumm_load              AS TransportSumm_load
                             , spSelect.TransportSumm                   AS TransportSumm
                               --
                             , COALESCE (spSelect.NPP,0)       ::TFloat AS NPP
                             , COALESCE (spSelect.SummReal, 0) ::TFloat AS SummReal
                             , spSelect.SummTax                         AS SummTax
                               -- ***Total LP - ����� � ������ ���� % ������, ��� ����������, ����� ������� ��� ���
                             , COALESCE (spSelect.Basis_summ, 0)        AS TotalSumm

                        FROM gpGet_Movement_OrderClient (inMovementId_OrderClient, CURRENT_DATE, inSession) AS spSelect
                       )

           -- ������ ���� ��� ����
         , tmpInvoice AS (SELECT Movement.Id              AS MovementId_Invoice
                               , Movement.ParentId        AS MovementId_OrderClient
                               , Movement.OperDate
                               , Movement.InvNumber
                               , Movement.StatusId
                               , Object_Status.ObjectCode AS StatusCode
                               , Object_Status.ValueData  AS StatusName
                                 -- � ���
                               , CASE WHEN MovementLinkObject_InvoiceKind.ObjectId = zc_Enum_InvoiceKind_Return()
                                      THEN 0
                                      ELSE MovementFloat_Amount.ValueData     
                                 END ::TFloat AS AmountIn
                                 -- ������ ����
                                 -- , ROW_NUMBER () OVER (ORDER BY Movement.OperDate ASC, Movement.Id ASC) AS Ord
                          FROM Movement
                               LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                               LEFT JOIN MovementFloat AS MovementFloat_Amount
                                                       ON MovementFloat_Amount.MovementId = Movement.Id
                                                      AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                                            ON MovementLinkObject_InvoiceKind.MovementId = Movement.Id
                                                           AND MovementLinkObject_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()

                          WHERE Movement.ParentId = inMovementId_OrderClient
                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                            AND Movement.DescId   = zc_Movement_Invoice()
                         )

       -- ������ �� ������ ������
   /*  , tmpBankAccount AS (SELECT MovementLinkMovement.MovementChildId AS MovementId_Invoice
                               , SUM (MovementItem.Amount)   ::TFloat AS AmountIn 
                          FROM MovementLinkMovement
                               INNER JOIN Movement AS Movement_BankAccount
                                                   ON Movement_BankAccount.Id       = MovementLinkMovement.MovementId
                                                  AND Movement_BankAccount.StatusId = zc_Enum_Status_Complete()   ---<> zc_Enum_Status_Erased()
                                                  AND Movement_BankAccount.DescId   = zc_Movement_BankAccount()
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement_BankAccount.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                          WHERE MovementLinkMovement.MovementChildId IN (SELECT DISTINCT tmpInvoice.MovementId_Invoice FROM tmpInvoice)
                            AND MovementLinkMovement.DescId          = zc_MovementLinkMovement_Invoice()
                          GROUP BY MovementLinkMovement.MovementChildId
                         )
*/
      -- ����� ��� ������
     , tmpBankAccount AS (SELECT tmp.MovementId_Invoice :: Integer AS MovementId_Invoice
                               , SUM (CASE WHEN MovementItem.Amount > 0 THEN MovementItem.Amount      ELSE 0 END) ::TFloat AS AmountIn
                               , SUM (CASE WHEN MovementItem.Amount < 0 THEN -1 * MovementItem.Amount ELSE 0 END) ::TFloat AS AmountOut
                               , SUM (COALESCE (MovementItem.Amount,0)) AS Amount
                          FROM (SELECT DISTINCT tmpInvoice.MovementId_Invoice FROM tmpInvoice) AS tmp
                               INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                            ON MIFloat_MovementId.ValueData = tmp.MovementId_Invoice
                                                           AND MIFloat_MovementId.DescId    = zc_MIFloat_MovementId()
                               INNER JOIN MovementItem ON MovementItem.Id       = MIFloat_MovementId.MovementItemId
                                                      AND MovementItem.DescId   = zc_MI_Child()
                                                      AND MovementItem.isErased = FALSE
                               INNER JOIN Movement AS Movement_BankAccount ON Movement_BankAccount.Id       = MovementItem.MovementId
                                                                          AND Movement_BankAccount.StatusId <> zc_Enum_Status_Erased() -- zc_Enum_Status_Complete()
                                                                          AND Movement_BankAccount.DescId   = zc_Movement_BankAccount()
                          GROUP BY tmp.MovementId_Invoice
                         )



     SELECT
           Object_Product.Id             AS Id
         , Object_Product.ObjectCode     AS Code
         , Object_Product.ValueData      AS Name

         , ObjectFloat_Hours.ValueData      AS Hours
         , tmpOrderClient.DiscountTax       AS DiscountTax
         , tmpOrderClient.DiscountNextTax   AS DiscountNextTax
         , tmpOrderClient.SummReal ::TFloat
         , tmpOrderClient.SummTax  ::TFloat

         , ObjectDate_DateStart.ValueData   AS DateStart
         , ObjectDate_DateBegin.ValueData   AS DateBegin
         , ObjectDate_DateSale.ValueData    AS DateSale
         , ObjectString_CIN.ValueData       AS CIN
         , ObjectString_EngineNum.ValueData AS EngineNum
         , ObjectString_Comment.ValueData   AS Comment

         , Object_Brand.Id                  AS BrandId
         , Object_Brand.ValueData           AS BrandName

         , Object_Model.Id                  AS ModelId
         , Object_Model.ValueData           AS ModelName
         , (Object_Model.ValueData ||' (' || Object_Brand_Model.ValueData||')') ::TVarChar AS ModelName_full

         , Object_Engine.Id                 AS EngineId
         , Object_Engine.ValueData          AS EngineName

         , Object_ReceiptProdModel.Id        AS ReceiptProdModelId
         , Object_ReceiptProdModel.ValueData AS ReceiptProdModelName

         , tmpOrderClient.ClientId                 AS ClientId
         , tmpOrderClient.ClientName               AS ClientName
         , tmpOrderClient.TaxKindId                AS TaxKindId_Client
         , tmpOrderClient.TaxKindName              AS TaxKindName_Client

         , tmpOrderClient.MovementId :: Integer    AS MovementId_OrderClient
         , tmpOrderClient.OperDate   :: TDateTime  AS OperDate_OrderClient
         , zfCalc_InvNumber_isErased ('', tmpOrderClient.InvNumber, tmpOrderClient.OperDate, tmpOrderClient.StatusId) AS InvNumber_OrderClient
         , tmpOrderClient.InvNumber   :: TVarChar  AS InvNumber_OrderClient_load
         , tmpOrderClient.StatusCode  :: Integer   AS StatusCode_OrderClient
         , tmpOrderClient.StatusName  :: TVarChar  AS StatusName_OrderClient
         , COALESCE (tmpOrderClient.VATPercent, 0) :: TFloat AS VATPercent_OrderClient
         , tmpOrderClient.NPP         :: TFloat    AS NPP_OrderClient

           -- ����� ����� ������� ��� ��� - �� ����� �������� (Basis+options) + TRANSPORT
         , (tmpOrderClient.TotalSumm
            -- ����� ������������������ ������
          - COALESCE (tmpOrderClient.SummTax, 0)
            -- ���� ���������
          + COALESCE (tmpOrderClient.TransportSumm_load, 0)
          + COALESCE (tmpOrderClient.TransportSumm, 0)
           ) :: TFloat AS TotalSummMVAT

           -- ����� ����� ������� � ��� - �� ����� �������� (Basis+options) + TRANSPORT
         , (zfCalc_SummWVAT (
            tmpOrderClient.TotalSumm
            -- ����� ������������������ ������
          - tmpOrderClient.SummTax
            -- ���� ���������
          + tmpOrderClient.TransportSumm_load
          + tmpOrderClient.TransportSumm
            -- ���� ���
          , tmpOrderClient.VATPercent)
           ) :: TFloat AS TotalSummPVAT

           -- ����� ���
         , zfCalc_Summ_VAT (zfCalc_SummWVAT (
                            tmpOrderClient.TotalSumm
                            -- ����� ������������������ ������
                          - tmpOrderClient.SummTax
                            -- ���� ���������
                          + tmpOrderClient.TransportSumm_load
                          + tmpOrderClient.TransportSumm
                            -- ���� ���
                          , tmpOrderClient.VATPercent)
                            -- � ������ ������ ���
                          , tmpOrderClient.VATPercent
                           )  :: TFloat AS TotalSummVAT

         , (tmpOrderClient.Basis_summ_orig + COALESCE (tmpOrderClient.TransportSumm_load, 0)+ COALESCE (tmpOrderClient.TransportSumm, 0))   :: TFloat AS OperPrice_load
         , tmpOrderClient.TransportSumm_load  :: TFloat AS TransportSumm_load
         , tmpOrderClient.TransportSumm       :: TFloat AS TransportSumm  
         
         , COALESCE (tmpOrderClient.SummDiscount_total, 0) :: TFloat AS SummDiscount_total
          -- ***Total LP - ����� � ������ ���� % ������, ��� ����������, ����� ������� ��� ���
         , COALESCE (tmpOrderClient.TotalSumm, 0)          :: TFloat AS Basis_summ   
          -- *Total LP (Basis + Opt) - ����� ��� ����� ������ � ����������, ����� ������� ��� ���
         , COALESCE (tmpOrderClient.Basis_summ_orig, 0)    :: TFloat AS Basis_summ_orig
           -- ����� ����� ������� ��� ��� - ��� ������ (Basis) 
         , COALESCE (tmpOrderClient.Basis_summ1_orig, 0)   :: TFloat AS Basis_summ1_orig
           -- ����� ����� ������� ��� ��� - ��� ������ (options)
         , COALESCE (tmpOrderClient.Basis_summ2_orig, 0)   :: TFloat AS Basis_summ2_orig
         ---, (COALESCE (tmpOrderClient.TotalSumm,0) - COALESCE (tmpOrderClient.SummTax,0) ) ::TFloat AS SummReal 

         , COALESCE (ObjectBoolean_BasicConf.ValueData, FALSE) :: Boolean AS isBasicConf
         , COALESCE (ObjectBoolean_Reserve.ValueData, FALSE)   :: Boolean AS isReserve
         , CAST (FALSE AS Boolean)          AS isProdColorPattern

         , tmpInvoice_main.MovementId_Invoice :: Integer    AS MovementId_Invoice
         , tmpInvoice_main.OperDate           :: TDateTime  AS OperDate_Invoice
         , zfCalc_InvNumber_isErased ('', tmpInvoice_main.InvNumber, tmpInvoice_main.OperDate, tmpInvoice_main.StatusId) AS InvNumber_Invoice
         , tmpInvoice_main.StatusCode         :: Integer    AS StatusCode_Invoice
         , tmpInvoice_main.StatusName         :: TVarChar   AS StatusName_Invoice   
         
         , 0 ::Integer                   AS MovementId_BankAccount
         , ''               :: TVarChar  AS InvNumber_BankAccount
         , NULL             :: TDateTime AS OperDate_BankAccount 
         , 0                ::Integer    AS BankAccountId
         , ''               :: TVarChar  AS BankAccountName
         
          -- ����� ������� �����
         , tmpInvoice_main.AmountIn           ::TFloat AS AmountIn_Invoice
           -- ����� �� ���� ������
         , tmpInvoice.AmountIn                 ::TFloat AS AmountIn_InvoiceAll

           -- ����� ������ �� ������� �����
         , tmpBankAccount_First.AmountIn       ::TFloat AS AmountIn_BankAccount
           -- ����� �� ���� �������
         , tmpBankAccount.AmountIn             ::TFloat AS AmountIn_BankAccountAll
           -- ������ ???
         , 0                                   ::TFloat AS AmountIn_BankAccountLast

           -- ����� ������� � ������ �� ���� ������
         , (COALESCE (tmpInvoice.AmountIn, 0) - COALESCE (tmpBankAccount.AmountIn,0))              ::TFloat AS AmountIn_rem
           -- ����� ������� � ������ �� �����
         , (zfCalc_SummWVAT (
            COALESCE (tmpOrderClient.TotalSumm,0)
            -- ����� ������������������ ������
          - tmpOrderClient.SummTax
            -- ���� ���������
          + tmpOrderClient.TransportSumm_load
          + tmpOrderClient.TransportSumm
            -- ���� ���
          , tmpOrderClient.VATPercent)
            -- ������
          - COALESCE (tmpBankAccount.AmountIn,0)
           ) ::TFloat AS AmountIn_remAll

         --  ��� �������� ��������� ������� �������� � ���������
         , lpInsertUpdate_MovementFloat (zc_MovementFloat_SummTax_calc(), tmpOrderClient.MovementId, COALESCE (tmpOrderClient.SummTax, 0)) ::integer
         , lpInsertUpdate_MovementFloat (zc_MovementFloat_SummReal_calc(), tmpOrderClient.MovementId, COALESCE (tmpOrderClient.TotalSumm, 0) - COALESCE (tmpOrderClient.SummTax,0))::integer
         , lpInsertUpdate_MovementFloat (zc_MovementFloat_TransportSumm_load_calc(), tmpOrderClient.MovementId, tmpOrderClient.TransportSumm_load)::integer
         , lpInsertUpdate_MovementFloat (zc_MovementFloat_TransportSumm_calc(), tmpOrderClient.MovementId, tmpOrderClient.TransportSumm)::integer
         , lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent_calc(), tmpOrderClient.MovementId, COALESCE (tmpOrderClient.VATPercent, 0) )::integer
         , lpInsertUpdate_MovementFloat (zc_MovementFloat_Basis_summ_transport_calc(), tmpOrderClient.MovementId, (tmpOrderClient.TotalSumm
                                                                                                                   -- ����� ������������������ ������
                                                                                                                 - COALESCE (tmpOrderClient.SummTax, 0)
                                                                                                                   -- ���� ���������
                                                                                                                 + COALESCE (tmpOrderClient.TransportSumm_load, 0)+ COALESCE (tmpOrderClient.TransportSumm, 0)
                                                                                                                  ))    ::integer
         , lpInsertUpdate_MovementFloat (zc_MovementFloat_BasisWVAT_summ_transport_calc(), tmpOrderClient.MovementId, (zfCalc_SummWVAT (
                                                                                                                       tmpOrderClient.TotalSumm
                                                                                                                       -- ����� ������������������ ������
                                                                                                                     - tmpOrderClient.SummTax
                                                                                                                       -- ���� ���������
                                                                                                                     + tmpOrderClient.TransportSumm_load
                                                                                                                     + tmpOrderClient.TransportSumm
                                                                                                                       -- ���� ���
                                                                                                                     , tmpOrderClient.VATPercent)
                                                                                                                       ))::integer
         , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isVat_calc(), tmpOrderClient.MovementId, FALSE)  ::integer
 
     FROM Object AS Object_Product
          -- �������� ������� ������������ 
          LEFT JOIN ObjectBoolean AS ObjectBoolean_BasicConf
                                  ON ObjectBoolean_BasicConf.ObjectId = Object_Product.Id
                                 AND ObjectBoolean_BasicConf.DescId   = zc_ObjectBoolean_Product_BasicConf()
          -- ��������������� ����� � ������������ �������������
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Reserve
                                  ON ObjectBoolean_Reserve.ObjectId = Object_Product.Id
                                 AND ObjectBoolean_Reserve.DescId   = zc_ObjectBoolean_Product_Reserve()

          LEFT JOIN ObjectFloat AS ObjectFloat_Hours
                                ON ObjectFloat_Hours.ObjectId = Object_Product.Id
                               AND ObjectFloat_Hours.DescId = zc_ObjectFloat_Product_Hours()

          LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax
                                ON ObjectFloat_DiscountTax.ObjectId = Object_Product.Id
                               AND ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Product_DiscountTax()
          LEFT JOIN ObjectFloat AS ObjectFloat_DiscountNextTax
                                ON ObjectFloat_DiscountNextTax.ObjectId = Object_Product.Id
                               AND ObjectFloat_DiscountNextTax.DescId = zc_ObjectFloat_Product_DiscountNextTax()

          LEFT JOIN ObjectDate AS ObjectDate_DateStart
                               ON ObjectDate_DateStart.ObjectId = Object_Product.Id
                              AND ObjectDate_DateStart.DescId = zc_ObjectDate_Product_DateStart()

          LEFT JOIN ObjectDate AS ObjectDate_DateBegin
                               ON ObjectDate_DateBegin.ObjectId = Object_Product.Id
                              AND ObjectDate_DateBegin.DescId = zc_ObjectDate_Product_DateBegin()

          LEFT JOIN ObjectDate AS ObjectDate_DateSale
                               ON ObjectDate_DateSale.ObjectId = Object_Product.Id
                              AND ObjectDate_DateSale.DescId = zc_ObjectDate_Product_DateSale()

          LEFT JOIN ObjectString AS ObjectString_CIN
                                 ON ObjectString_CIN.ObjectId = Object_Product.Id
                                AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()

          LEFT JOIN ObjectString AS ObjectString_EngineNum
                                 ON ObjectString_EngineNum.ObjectId = Object_Product.Id
                                AND ObjectString_EngineNum.DescId = zc_ObjectString_Product_EngineNum()

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Product.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_Product_Comment()

          /*LEFT JOIN ObjectLink AS ObjectLink_ProdGroup
                               ON ObjectLink_ProdGroup.ObjectId = Object_Product.Id
                              AND ObjectLink_ProdGroup.DescId = zc_ObjectLink_Product_ProdGroup()
          LEFT JOIN Object AS Object_ProdGroup ON Object_ProdGroup.Id = ObjectLink_ProdGroup.ChildObjectId
          */

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                               ON ObjectLink_ReceiptProdModel.ObjectId = Object_Product.Id
                              AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_Product_ReceiptProdModel()
          LEFT JOIN Object AS Object_ReceiptProdModel ON Object_ReceiptProdModel.Id = ObjectLink_ReceiptProdModel.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Brand
                               ON ObjectLink_Brand.ObjectId = Object_Product.Id
                              AND ObjectLink_Brand.DescId = zc_ObjectLink_Product_Brand()
          LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Model
                               ON ObjectLink_Model.ObjectId = Object_Product.Id
                              AND ObjectLink_Model.DescId = zc_ObjectLink_Product_Model()
          LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ProdModel_Brand
                               ON ObjectLink_ProdModel_Brand.ObjectId = Object_Model.Id
                              AND ObjectLink_ProdModel_Brand.DescId = zc_ObjectLink_ProdModel_Brand()
          LEFT JOIN Object AS Object_Brand_Model ON Object_Brand_Model.Id = ObjectLink_ProdModel_Brand.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Engine
                               ON ObjectLink_Engine.ObjectId = Object_Product.Id
                              AND ObjectLink_Engine.DescId = zc_ObjectLink_Product_Engine()
          LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Engine.ChildObjectId

          LEFT JOIN tmpOrderClient ON 1=1

          /*LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                  ON MovementFloat_TotalSumm.MovementId = tmpOrderClient.MovementId
                                 AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm() */

          -- ������ �����
          LEFT JOIN MovementLinkMovement AS MLM_Invoice
                                         ON MLM_Invoice.MovementId = tmpOrderClient.MovementId
                                        AND MLM_Invoice.DescId     = zc_MovementLinkMovement_Invoice()
          LEFT JOIN tmpInvoice AS tmpInvoice_main ON tmpInvoice_main.MovementId_Invoice = MLM_Invoice.MovementChildId

          -- ����� ������ �� ������� �����
          LEFT JOIN tmpBankAccount AS tmpBankAccount_first ON tmpBankAccount_first.MovementId_Invoice = tmpInvoice_main.MovementId_Invoice
          -- ����� �� ���� ������
          LEFT JOIN (SELECT SUM (COALESCE (tmpInvoice.AmountIn,0)) AS AmountIn FROM tmpInvoice) AS tmpInvoice ON 1 = 1
          -- ����� �� ���� �������
          LEFT JOIN (SELECT SUM (COALESCE (tmpBankAccount.AmountIn,0)) AS AmountIn FROM tmpBankAccount) AS tmpBankAccount ON 1 = 1 
          
          /*LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                               ON ObjectLink_TaxKind.ObjectId = tmpOrderClient.ClientId
                              AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Client_TaxKind()
          LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId
          */
       WHERE Object_Product.Id = inId
       --LIMIT 1
      ;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.04.24         *
 24.06.23         *
 15.05.23         *
 05.02.23         *
 04.01.21         *
 08.10.20         *
*/

-- ����
-- SELECT * FROM gpGet_Object_Product (inId:= 2539, inMovementId_OrderClient:= 80, inSession:= zfCalc_UserAdmin());
