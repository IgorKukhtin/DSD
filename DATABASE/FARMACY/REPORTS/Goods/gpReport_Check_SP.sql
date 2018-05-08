-- Function:  gpReport_Check_SP()

DROP FUNCTION IF EXISTS gpReport_Check_SP (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Check_SP (TDateTime, TDateTime, Integer,Integer,Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_SP(
    IN inStartDate        TDateTime,  -- ���� ������
    IN inEndDate          TDateTime,  -- ���� ���������
    IN inJuridicalId      Integer  ,  -- ��.����
    IN inUnitId           Integer  ,  -- ������
    IN inHospitalId       Integer  ,  -- ��������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementId     Integer
             , UnitName       TVarChar
             , JuridicalId    Integer
             , JuridicalName  TVarChar
             , HospitalId     Integer
             , HospitalName   TVarChar
             , GoodsCode      Integer
             , GoodsName      TVarChar
             , IntenalSPName  TVarChar
             , BrandSPName    TVarChar
             , KindOutSPName  TVarChar
             , Pack           TVarChar
             , CountSP        TFloat
             , PriceSP        TFloat 
             , GroupSP        TFloat 
             , CodeATX        TVarChar
             , ReestrSP       TVarChar
             , MakerSP        TVarChar
             , DateReestrSP   TVarChar
             , PriceOptSP     TFloat
             , PriceRetSP     TFloat
             , DailyNormSP    TFloat
             , DailyCompensationSP  TFloat
             , PaymentSP      TFloat
             , ColSP          TFloat
             , InsertDateSP   TDateTime

             , Amount         TFloat
             , PriceSale      TFloat
             , PriceCheckSP   TFloat 
             , SummaSP        TFloat 
             , NumLine        Integer
             , CountInvNumberSP  Integer

             , JuridicalFullName  TVarChar
             , JuridicalAddress   TVarChar
             , OKPO               TVarChar
             , MainName           TVarChar
             , MainName_Cut       TVarChar
             , AccounterName      TVarChar
             , INN                TVarChar
             , NumberVAT          TVarChar
             , BankAccount        TVarChar
             , Phone              TVarChar
             , BankName           TVarChar
             , MFO                TVarChar
  
             , PartnerMedical_FullName         TVarChar
             , PartnerMedical_JuridicalAddress TVarChar
             , PartnerMedical_OKPO             TVarChar
             , PartnerMedical_Phone            TVarChar
             /*
             , PartnerMedical_AccounterName    TVarChar
             , PartnerMedical_INN              TVarChar
             , PartnerMedical_NumberVAT        TVarChar*/
             , PartnerMedical_BankAccount      TVarChar
             , PartnerMedical_BankName         TVarChar
             , PartnerMedical_MFO              TVarChar
             , ContractId          Integer
             , ContractName        TVarChar
             , Contract_StartDate                 TDateTime
             , Contract_SigningDate               TDateTime
             , MedicSPName                        TVarChar
             , InvNumberSP                        TVarChar
             , OperDateSP                         TDateTime
             , OperDate                           TDateTime
  
             , InvNumber_Invoice      TVarChar
             , InvNumber_Invoice_Full TVarChar
             , OperDate_Invoice       TDateTime
             , TotalSumm_Invoice      TFloat

)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartYear TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    
    vbStartYear := (SELECT DATE_TRUNC ('YEAR' ,inStartDate)) ::TDateTime;
    
    -- �������
    CREATE TEMP TABLE tmpUnit (UnitId Integer, JuridicalId Integer) ON COMMIT DROP;
 
    IF (COALESCE (inJuridicalId,0) <> 0) OR (COALESCE (inUnitId,0) <> 0) THEN
       INSERT INTO tmpUnit (UnitId, JuridicalId)
                  SELECT OL_Unit_Juridical.ObjectId       AS UnitId
                       , OL_Unit_Juridical.ChildObjectId  AS JuridicalId
                  FROM ObjectLink AS OL_Unit_Juridical
                  WHERE OL_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                    AND ((OL_Unit_Juridical.ChildObjectId = inJuridicalId AND COALESCE (inUnitId,0) = 0)
                          OR OL_Unit_Juridical.ObjectId = inUnitId);
    ELSE 
       INSERT INTO tmpUnit (UnitId, JuridicalId)
                  SELECT OL_Unit_Juridical.ObjectId AS UnitId
                       , OL_Unit_Juridical.ChildObjectId  AS JuridicalId
                  FROM ObjectLink AS OL_Unit_Juridical
                  WHERE OL_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical();
    END IF;

    -- ���������
    RETURN QUERY
          WITH
          -- �������� ������ ����. ������� (�������)
          tmpGoodsSP AS (SELECT ObjectBoolean_Goods_SP.ObjectId              AS GoodsMainId
                              , ObjectLink_Goods_IntenalSP.ChildObjectId     AS IntenalSPId
                              , Object_IntenalSP.ValueData                   AS IntenalSPName
                              , ObjectLink_Goods_BrandSP.ChildObjectId       AS BrandSPId
                              , Object_BrandSP.ValueData                     AS BrandSPName
                              , ObjectLink_Goods_KindOutSP.ChildObjectId     AS KindOutSPId
                              , Object_KindOutSP.ValueData                   AS KindOutSPName

                              , ObjectFloat_Goods_PriceSP.ValueData          AS PriceSP
                              , ObjectFloat_Goods_GroupSP.ValueData          AS GroupSP
                              , ObjectFloat_Goods_CountSP.ValueData          AS CountSP
                              , ObjectString_Goods_Pack.ValueData            AS Pack  --���������

                              , ObjectString_Goods_CodeATX.ValueData         AS CodeATX 
                              , ObjectString_Goods_ReestrSP.ValueData        AS ReestrSP
                              , ObjectString_Goods_MakerSP.ValueData         AS MakerSP
                              , ObjectString_Goods_ReestrDateSP.ValueData    AS DateReestrSP
                              , ObjectFloat_Goods_PriceOptSP.ValueData       AS PriceOptSP
                              , ObjectFloat_Goods_PriceRetSP.ValueData       AS PriceRetSP
                              , ObjectFloat_Goods_DailyNormSP.ValueData      AS DailyNormSP
                              , ObjectFloat_Goods_DailyCompensationSP.ValueData  AS DailyCompensationSP
                              , ObjectFloat_Goods_PaymentSP.ValueData        AS PaymentSP
                              , ObjectFloat_Goods_ColSP.ValueData            AS ColSP
                              , ObjectDate_InsertSP.ValueData                AS InsertDateSP

                          FROM ObjectBoolean AS ObjectBoolean_Goods_SP 
                               LEFT JOIN ObjectLink AS ObjectLink_Goods_Object 
                                 ON ObjectLink_Goods_Object.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_IntenalSP
                                 ON ObjectLink_Goods_IntenalSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectLink_Goods_IntenalSP.DescId = zc_ObjectLink_Goods_IntenalSP()
                               LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = ObjectLink_Goods_IntenalSP.ChildObjectId
        
                               LEFT JOIN ObjectLink AS ObjectLink_Goods_BrandSP
                                 ON ObjectLink_Goods_BrandSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectLink_Goods_BrandSP.DescId = zc_ObjectLink_Goods_BrandSP()
                               LEFT JOIN Object AS Object_BrandSP ON Object_BrandSP.Id = ObjectLink_Goods_BrandSP.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_KindOutSP
                                 ON ObjectLink_Goods_KindOutSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectLink_Goods_KindOutSP.DescId = zc_ObjectLink_Goods_KindOutSP()
                               LEFT JOIN Object AS Object_KindOutSP ON Object_KindOutSP.Id = ObjectLink_Goods_KindOutSP.ChildObjectId

                               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceSP
                                 ON ObjectFloat_Goods_PriceSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectFloat_Goods_PriceSP.DescId = zc_ObjectFloat_Goods_PriceSP()   
                               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_GroupSP
                                 ON ObjectFloat_Goods_GroupSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectFloat_Goods_GroupSP.DescId = zc_ObjectFloat_Goods_GroupSP()

                               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_CountSP
                                 ON ObjectFloat_Goods_CountSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectFloat_Goods_CountSP.DescId = zc_ObjectFloat_Goods_CountSP()

                               LEFT JOIN ObjectString AS ObjectString_Goods_Pack
                                 ON ObjectString_Goods_Pack.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                AND ObjectString_Goods_Pack.DescId = zc_ObjectString_Goods_Pack()
    
                               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceOptSP
                                                     ON ObjectFloat_Goods_PriceOptSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                                    AND ObjectFloat_Goods_PriceOptSP.DescId = zc_ObjectFloat_Goods_PriceOptSP() 
                               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceRetSP
                                                     ON ObjectFloat_Goods_PriceRetSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                                    AND ObjectFloat_Goods_PriceRetSP.DescId = zc_ObjectFloat_Goods_PriceRetSP() 
                               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_DailyNormSP
                                                     ON ObjectFloat_Goods_DailyNormSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                                    AND ObjectFloat_Goods_DailyNormSP.DescId = zc_ObjectFloat_Goods_DailyNormSP() 
                               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_DailyCompensationSP
                                                     ON ObjectFloat_Goods_DailyCompensationSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                                    AND ObjectFloat_Goods_DailyCompensationSP.DescId = zc_ObjectFloat_Goods_DailyCompensationSP() 
                               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PaymentSP
                                                     ON ObjectFloat_Goods_PaymentSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                                    AND ObjectFloat_Goods_PaymentSP.DescId = zc_ObjectFloat_Goods_PaymentSP() 
                               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_ColSP
                                                     ON ObjectFloat_Goods_ColSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                                    AND ObjectFloat_Goods_ColSP.DescId = zc_ObjectFloat_Goods_ColSP() 

                               LEFT JOIN ObjectString AS ObjectString_Goods_CodeATX
                                                      ON ObjectString_Goods_CodeATX.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                                     AND ObjectString_Goods_CodeATX.DescId = zc_ObjectString_Goods_CodeATX()
                               LEFT JOIN ObjectString AS ObjectString_Goods_ReestrSP
                                                      ON ObjectString_Goods_ReestrSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                                     AND ObjectString_Goods_ReestrSP.DescId = zc_ObjectString_Goods_ReestrSP()
                               LEFT JOIN ObjectString AS ObjectString_Goods_MakerSP
                                                      ON ObjectString_Goods_MakerSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                                     AND ObjectString_Goods_MakerSP.DescId = zc_ObjectString_Goods_MakerSP()
                               LEFT JOIN ObjectString AS ObjectString_Goods_ReestrDateSP
                                                      ON ObjectString_Goods_ReestrDateSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                                     AND ObjectString_Goods_ReestrDateSP.DescId = zc_ObjectString_Goods_ReestrDateSP()
                               LEFT JOIN ObjectDate AS ObjectDate_InsertSP
                                                    ON ObjectDate_InsertSP.ObjectId = ObjectBoolean_Goods_SP.ObjectId
                                                   AND ObjectDate_InsertSP.DescId = zc_ObjectDate_Protocol_InsertSP()
     
                          WHERE ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()
                          --  AND ObjectBoolean_Goods_SP.ValueData = TRUE
                         )
           -- ��������� ������� ������ � �������� ����
           , tmpGoods AS (SELECT ObjectLink_Child.ChildObjectId AS GoodsId
                               , tmpGoodsSP.GoodsMainId
                          FROM tmpGoodsSP
                               INNER JOIN ObjectLink AS ObjectLink_Main
                                  ON ObjectLink_Main.ChildObjectId = tmpGoodsSP.GoodsMainId
                                 AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                               INNER JOIN ObjectLink AS ObjectLink_Child 
                                  ON ObjectLink_Child.ObjectId = ObjectLink_Main.ObjectId
                                 AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                 AND COALESCE (ObjectLink_Child.ChildObjectId,0)<>0
                          )
            -- �������� ������� �� ������� ���.�������
          /*  ,  tmpMI AS (SELECT Movement_Check.Id                                         AS MovementId 
                              , Movement_Check.OperDate
                              , MovementLinkObject_Unit.ObjectId                          AS UnitId
                              , tmpUnit.JuridicalId
                              , MovementLinkObject_PartnerMedical.ObjectId                AS HospitalId
                              , MAX (CASE WHEN MIFloat_SummChangePercent.ValueData < 0 THEN Movement_Check.Id ELSE 0 END) AS MovementId_err
                              , tmpGoods.GoodsMainId                                      AS GoodsMainId
                              , SUM (MI_Check.Amount) AS Amount
                              , SUM (COALESCE (MIFloat_SummChangePercent.ValueData, 0))   AS SummChangePercent
                              , COALESCE (MIFloat_PriceSale.ValueData, 0)                 AS PriceSale
                              , MAX (CASE WHEN date_trunc ('day', Movement_Check.OperDate) = '01.06.2017' ::TDateTime
                                               THEN CAST (COALESCE (MIFloat_PriceSale.ValueData, 0) - COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC(16,2))
                                          ELSE 0
                                     END)                                                 AS Price_calc
                              , MovementString_InvNumberSP.ValueData                      AS InvNumberSP
                              , MovementString_MedicSP.ValueData                          AS MedicSPName
                              , MovementDate_OperDateSP.ValueData                         AS OperDateSP
                              
                              , Movement_Invoice.InvNumber                 :: TVarChar    AS InvNumber_Invoice 
                              , ('� ' || Movement_Invoice.InvNumber || ' �� ' || Movement_Invoice.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Invoice_Full 
                         FROM Movement AS Movement_Check
                              INNER JOIN MovementString AS MovementString_InvNumberSP
                                                        ON MovementString_InvNumberSP.MovementId = Movement_Check.Id
                                                       AND MovementString_InvNumberSP.ValueData <> ''
                                                       AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                              INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
 
                              LEFT JOIN MovementString AS MovementString_MedicSP
                                     ON MovementString_MedicSP.MovementId = Movement_Check.Id
                                    AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                                           ON MovementLinkObject_PartnerMedical.MovementId = Movement_Check.Id
                                                          AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                              LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                                     ON MovementDate_OperDateSP.MovementId = Movement_Check.Id
                                                    AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()
                              -- ����
                              LEFT JOIN MovementLinkMovement AS MLM_Child
                                     ON MLM_Child.MovementId = Movement_Check.Id
                                    AND MLM_Child.descId = zc_MovementLinkMovement_Child()
                              LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Child.MovementChildId

                              -- ��� ����� �������� ����������� �� ��������
                              INNER JOIN MovementItem AS MI_Check
                                                      ON MI_Check.MovementId = Movement_Check.Id
                                                     AND MI_Check.DescId = zc_MI_Master()
                                                     AND MI_Check.Amount <> 0
                                                     AND MI_Check.isErased = FALSE

                              LEFT JOIN tmpGoods ON tmpGoods.GoodsId = MI_Check.ObjectId
                              --����� ������
                              LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                          ON MIFloat_SummChangePercent.MovementItemId = MI_Check.Id
                                                         AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()
                              LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                          ON MIFloat_PriceSale.MovementItemId = MI_Check.Id
                                                         AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MI_Check.Id
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()

                         WHERE Movement_Check.DescId = zc_Movement_Check()
                           AND Movement_Check.OperDate >= inStartDate AND Movement_Check.OperDate < inEndDate + INTERVAL '1 DAY'
                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                           AND (MovementLinkObject_PartnerMedical.ObjectId = inHospitalId OR inHospitalId = 0)
                         GROUP BY MovementLinkObject_Unit.ObjectId
                                , tmpUnit.JuridicalId
                                , tmpGoods.GoodsMainId
                                , movementlinkobject_partnermedical.objectid
                                , MovementString_InvNumberSP.ValueData
                                , MovementDate_OperDateSP.ValueData
                                , MovementString_MedicSP.ValueData          
                                , Movement_Check.OperDate, Movement_Check.Id
                                , COALESCE (MIFloat_PriceSale.ValueData, 0)
                                , Movement_Invoice.InvNumber 
                                , ('� ' || Movement_Invoice.InvNumber || ' �� ' || Movement_Invoice.OperDate  :: Date :: TVarChar )
                         HAVING SUM (MI_Check.Amount) <> 0
                        )*/

      -- �������� ������� �� ������� ���.�������
, tmpMovement_All AS (SELECT Movement_Check.Id                                         AS Id 
                              , Movement_Check.OperDate
                              , MovementLinkObject_Unit.ObjectId                          AS UnitId
                              , tmpUnit.JuridicalId
                              , MovementLinkObject_PartnerMedical.ObjectId                AS HospitalId
                              
                              , MovementString_InvNumberSP.ValueData                      AS InvNumberSP
                            /*  , MovementString_MedicSP.ValueData                          AS MedicSPName
                              , MovementDate_OperDateSP.ValueData                         AS OperDateSP
                          */    
                             
                         FROM Movement AS Movement_Check
                              INNER JOIN MovementString AS MovementString_InvNumberSP
                                                        ON MovementString_InvNumberSP.MovementId = Movement_Check.Id
                                                       AND MovementString_InvNumberSP.ValueData <> ''
                                                       AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                              INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                                           ON MovementLinkObject_PartnerMedical.MovementId = Movement_Check.Id
                                                          AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()

                         WHERE Movement_Check.DescId = zc_Movement_Check()
                           AND Movement_Check.OperDate >= inStartDate AND Movement_Check.OperDate < inEndDate + INTERVAL '1 DAY'
                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                           AND (MovementLinkObject_PartnerMedical.ObjectId = inHospitalId OR inHospitalId = 0)
              )


, tmpMovement AS (SELECT  Movement_Check.Id                                         AS Id 
                              , Movement_Check.OperDate
                              , Movement_Check.UnitId
                              , Movement_Check.JuridicalId
                              , Movement_Check.InvNumberSP
                              , Movement_Check.HospitalId
                              , MovementString_MedicSP.ValueData                          AS MedicSPName
                              , MovementDate_OperDateSP.ValueData                         AS OperDateSP
                              

              FROM tmpMovement_All AS Movement_Check
                              LEFT JOIN MovementString AS MovementString_MedicSP
                                     ON MovementString_MedicSP.MovementId = Movement_Check.Id
                                    AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()

                              LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                                     ON MovementDate_OperDateSP.MovementId = Movement_Check.Id
                                                    AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()
             )



, tmpMov AS (SELECT Movement_Check.Id                                         AS Id 
                              , Movement_Check.OperDate
                              , date_trunc ('day', Movement_Check.OperDate) AS OperDate_Calc
                              , Movement_Check.UnitId
                              , Movement_Check.JuridicalId
                              , Movement_Check.InvNumberSP
                              , Movement_Check.HospitalId
                              , Movement_Check.MedicSPName
                              , Movement_Check.OperDateSP
                            
                              , Movement_Invoice.InvNumber                 :: TVarChar    AS InvNumber_Invoice 
                              , ('� ' || Movement_Invoice.InvNumber || ' �� ' || Movement_Invoice.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Invoice_Full
                              , Movement_Invoice.OperDate                                 AS OperDate_Invoice

              FROM tmpMovement AS Movement_Check
                              -- ����
                              LEFT JOIN MovementLinkMovement AS MLM_Child
                                     ON MLM_Child.MovementId = Movement_Check.Id
                                    AND MLM_Child.descId = zc_MovementLinkMovement_Child()
                              LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Child.MovementChildId
            )

, tmpMI_Check AS (SELECT MI_Check.*
              FROM MovementItem AS MI_Check
               WHERE MI_Check.MovementId IN (SELECT tmpMov.Id FROM tmpMov)
                                                     AND MI_Check.DescId = zc_MI_Master()
                                                     AND MI_Check.Amount <> 0
                                                     AND MI_Check.isErased = FALSE
             )
             

, tmpMIFloat AS (SELECT *
                 FROM MovementItemFloat
                 WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Check.Id FROM tmpMI_Check) 
                                                 --     AND MovementItemFloat.DescId = zc_MIFloat_SummChangePercent()
                 )



, tmpMI AS (SELECT Movement_Check.Id      AS MovementId 
                              , Movement_Check.OperDate
                              , Movement_Check.OperDate_Calc
                              , Movement_Check.UnitId
                              , Movement_Check.JuridicalId
                              , Movement_Check.InvNumberSP
                              , Movement_Check.HospitalId
                              , Movement_Check.MedicSPName
                              , Movement_Check.OperDateSP
                              , Movement_Check.InvNumber_Invoice
                              , Movement_Check.InvNumber_Invoice_Full
                              , Movement_Check.OperDate_Invoice

                             , tmpGoods.GoodsMainId                                      AS GoodsMainId

                              , MAX (CASE WHEN MIFloat_SummChangePercent.ValueData < 0 THEN Movement_Check.Id ELSE 0 END) AS MovementId_err
                              , SUM (MI_Check.Amount) AS Amount
                              , SUM (COALESCE (MIFloat_SummChangePercent.ValueData, 0))   AS SummChangePercent
                              , COALESCE (MIFloat_PriceSale.ValueData, 0)                 AS PriceSale
                              , MAX (CASE WHEN Movement_Check.OperDate_Calc = '01.06.2017' ::TDateTime
                                               THEN CAST (COALESCE (MIFloat_PriceSale.ValueData, 0) - COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC(16,2))
                                          ELSE 0
                                     END)                                                 AS Price_calc

              FROM tmpMov AS Movement_Check
                              INNER JOIN tmpMI_Check AS MI_Check ON MI_Check.MovementId = Movement_Check.Id
                                                     
                              LEFT JOIN tmpGoods ON tmpGoods.GoodsId = MI_Check.ObjectId
                             --����� ������
                              LEFT JOIN tmpMIFloat AS MIFloat_SummChangePercent
                                                          ON MIFloat_SummChangePercent.MovementItemId = MI_Check.Id
                                                         AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()

                              LEFT JOIN tmpMIFloat AS MIFloat_PriceSale
                                                          ON MIFloat_PriceSale.MovementItemId = MI_Check.Id
                                                         AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

                              LEFT JOIN tmpMIFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MI_Check.Id
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()

                         GROUP BY Movement_Check.Id 
                              , Movement_Check.OperDate
                              , Movement_Check.OperDate_Calc
                              , Movement_Check.UnitId
                              , Movement_Check.JuridicalId
                              , Movement_Check.InvNumberSP
                              , Movement_Check.HospitalId
                              , Movement_Check.MedicSPName
                              , Movement_Check.OperDateSP
                            
                              , Movement_Check.InvNumber_Invoice
                              , Movement_Check.InvNumber_Invoice_Full
                              , Movement_Check.OperDate_Invoice

                               , tmpGoods.GoodsMainId
                                
                                , COALESCE (MIFloat_PriceSale.ValueData, 0)
                         HAVING  SUM (MI_Check.Amount) <> 0

            )



      , tmpBankAccount AS (SELECT ObjectLink_Juridical.ChildObjectId AS JuridicalId
                                , Object_BankAccount.Id
                                , Object_BankAccount.ValueData AS BankAccount
                                , Object_Bank.ValueData AS BankName
                                , ObjectString_MFO.ValueData AS MFO
                           FROM Object AS Object_BankAccount
                              LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                                   ON ObjectLink_Juridical.ObjectId = Object_BankAccount.Id
                                                  AND ObjectLink_Juridical.DescId = zc_ObjectLink_BankAccount_Juridical()
                              LEFT JOIN ObjectLink AS ObjectLink_Bank
                                                   ON ObjectLink_Bank.ObjectId = Object_BankAccount.Id
                                                  AND ObjectLink_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
                              LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Bank.ChildObjectId
                              LEFT JOIN ObjectString AS ObjectString_MFO
                                                     ON ObjectString_MFO.ObjectId = Object_Bank.Id 
                                                    AND ObjectString_MFO.DescId = zc_ObjectString_Bank_MFO()
                           WHERE Object_BankAccount.DescId = zc_object_BankAccount()
                           )

     , tmpParam AS (SELECT tmp.UnitId
                         , tmp.JuridicalId
                         , tmp.HospitalId
                        
                         , ObjectHistory_JuridicalDetails.FullName AS JuridicalFullName
                         , ObjectHistory_JuridicalDetails.JuridicalAddress
                         , ObjectHistory_JuridicalDetails.OKPO
                         , ObjectHistory_JuridicalDetails.MainName
                         , ObjectHistory_JuridicalDetails.MainName_Cut
                         , ObjectHistory_JuridicalDetails.AccounterName
                         , ObjectHistory_JuridicalDetails.INN
                         , ObjectHistory_JuridicalDetails.NumberVAT
                         , ObjectHistory_JuridicalDetails.BankAccount ::TVarChar AS BankAccount  --COALESCE (Object_BankAccount.ValueData,
                         , ObjectHistory_JuridicalDetails.Phone
                         , tmpBankAccount.BankName  ::TVarChar AS BankName --COALESCE (Object_Bank.ValueData,
                         , tmpBankAccount.MFO ::TVarChar AS MFO             --COALESCE (ObjectString_MFO.ValueData, 

                         , ObjectHistory_PartnerMedicalDetails.FullName          AS PartnerMedical_FullName
                         , ObjectHistory_PartnerMedicalDetails.JuridicalAddress  AS PartnerMedical_JuridicalAddress
                         , ObjectHistory_PartnerMedicalDetails.OKPO              AS PartnerMedical_OKPO
                         , ObjectHistory_PartnerMedicalDetails.Phone             AS PartnerMedical_Phone
                         , COALESCE(Object_PartnerMedical_Contract.Id,0)         AS PartnerMedical_ContractId
                         , Object_PartnerMedical_Contract.ValueData              AS PartnerMedical_ContractName
                         , ObjectDate_Signing.ValueData                          AS PartnerMedical_Contract_SigningDate
                         , ObjectDate_Start.ValueData                            AS PartnerMedical_Contract_StartDate 
                         , ObjectDate_End.ValueData                              AS PartnerMedical_Contract_EndDate 
                         , Object_BankAccount.ValueData                          AS PartnerMedical_BankAccount
                         , Object_Bank.ValueData                                 AS PartnerMedical_BankName
                         , ObjectString_MFO.ValueData                            AS PartnerMedical_MFO

                    FROM (SELECT DISTINCT tmpMI.UnitId
                               , tmpMI.JuridicalId
                               , tmpMI.HospitalId
                          FROM tmpMI) AS tmp
                         
                          LEFT JOIN ObjectLink AS ObjectLink_PartnerMedical_Juridical 
                                               ON ObjectLink_PartnerMedical_Juridical.ObjectId = tmp.HospitalId
                                              AND ObjectLink_PartnerMedical_Juridical.DescId = zc_ObjectLink_PartnerMedical_Juridical()

                          LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                               ON ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_PartnerMedical_Juridical.ChildObjectId
                                              AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                          LEFT JOIN Object AS Object_PartnerMedical_Contract ON Object_PartnerMedical_Contract.Id = ObjectLink_Contract_Juridical.ObjectId

                          INNER JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                                ON ObjectLink_Contract_JuridicalBasis.ObjectId = Object_PartnerMedical_Contract.Id 
                                               AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
                                               AND ObjectLink_Contract_JuridicalBasis.ChildObjectId = tmp.JuridicalId

                          LEFT JOIN ObjectLink AS ObjectLink_Contract_GroupMemberSP
                                               ON ObjectLink_Contract_GroupMemberSP.ObjectId = Object_PartnerMedical_Contract.Id
                                              AND ObjectLink_Contract_GroupMemberSP.DescId = zc_ObjectLink_Contract_GroupMemberSP()
                          LEFT JOIN Object AS Object_PartnerMedical_GroupMemberSP ON Object_PartnerMedical_GroupMemberSP.Id = ObjectLink_Contract_GroupMemberSP.ChildObjectId
      
                          LEFT JOIN ObjectDate AS ObjectDate_Start
                                               ON ObjectDate_Start.ObjectId = Object_PartnerMedical_Contract.Id
                                              AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
                          LEFT JOIN ObjectDate AS ObjectDate_End
                                               ON ObjectDate_End.ObjectId = Object_PartnerMedical_Contract.Id
                                              AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()
                          LEFT JOIN ObjectDate AS ObjectDate_Signing
                                               ON ObjectDate_Signing.ObjectId = Object_PartnerMedical_Contract.Id
                                              AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()

                          LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := tmp.JuridicalId, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_JuridicalDetails ON 1=1
                          LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := ObjectLink_PartnerMedical_Juridical.ChildObjectId, inFullName := '', inOKPO := '', inSession := inSession) AS ObjectHistory_PartnerMedicalDetails ON 1=1
       
                          LEFT JOIN tmpBankAccount ON tmpBankAccount.JuridicalId = tmp.JuridicalId
                                                  AND tmpBankAccount.BankAccount = ObjectHistory_JuridicalDetails.BankAccount

                          -- ��������� ���� �� �������� , �� ���� ��� ������� ������� ������'�
                          LEFT JOIN ObjectLink AS ObjectLink_Contract_BankAccount
                                                 ON ObjectLink_Contract_BankAccount.ObjectId = Object_PartnerMedical_Contract.Id
                                                AND ObjectLink_Contract_BankAccount.DescId = zc_ObjectLink_Contract_BankAccount()
                          LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = ObjectLink_Contract_BankAccount.ChildObjectId 
                          LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                               ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
                                              AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
                          LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId
                          LEFT JOIN ObjectString AS ObjectString_MFO
                                                 ON ObjectString_MFO.ObjectId = Object_Bank.Id
                                                AND ObjectString_MFO.DescId = zc_ObjectString_Bank_MFO()
                    WHERE COALESCE (Object_PartnerMedical_GroupMemberSP.ObjectCode,0) = -1
                    )

    , tmpCountR AS (SELECT  tmpData.JuridicalId
                          , tmpData.HospitalId
                          , tmpParam.PartnerMedical_ContractId AS ContractId
                          , COUNT ( DISTINCT tmpData.InvNumberSP) AS CountInvNumberSP
                    FROM (SELECT DISTINCT tmpMI.UnitId
                               , tmpMI.JuridicalId
                               , tmpMI.HospitalId
                               , tmpMI.InvNumberSP
                               , tmpMI.OperDate
                          FROM tmpMI) AS tmpData
                         LEFT JOIN tmpParam ON tmpParam.UnitId = tmpData.UnitId
                               AND tmpParam.JuridicalId = tmpData.JuridicalId
                               AND tmpParam.HospitalId = tmpData.HospitalId
                               AND tmpParam.PartnerMedical_Contract_StartDate <= tmpData.OperDate AND tmpParam.PartnerMedical_Contract_EndDate >= tmpData.OperDate
                    GROUP BY tmpData.JuridicalId
                           , tmpData.HospitalId
                           , tmpParam.PartnerMedical_ContractId
                    )

    , tmpInvoice AS (SELECT MovementLinkObject_PartnerMedical.ObjectId                     AS HospitalId
                          , MovementLinkObject_Juridical.ObjectId                          AS JuridicalId
                          , SUM (COALESCE (MovementFloat_TotalSumm.ValueData,0)) ::TFloat  AS TotalSumm
                     FROM Movement
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                       ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                      AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                          
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                                       ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                                      AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                          
                          LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                  ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                 AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                     WHERE Movement.DescId = zc_Movement_Invoice()
                       AND Movement.OperDate >= vbStartYear AND Movement.OperDate <inStartDate
                       AND Movement.StatusId = zc_Enum_Status_Complete()
                       AND (MovementLinkObject_Juridical.ObjectId = inJuridicalId OR inJuridicalId = 0)
                       AND (MovementLinkObject_PartnerMedical.ObjectId = inHospitalId OR inHospitalId = 0)
                     GROUP BY MovementLinkObject_PartnerMedical.ObjectId
                            , MovementLinkObject_Juridical.ObjectId
                     )

        -- ���������
        SELECT tmpData.MovementId
             , Object_Unit.ValueData               AS UnitName
             , Object_Juridical.Id                 AS JuridicalId
             , Object_Juridical.ValueData          AS JuridicalName

             , Object_PartnerMedical.Id            AS HospitalId
             , CASE WHEN tmpData.MovementId_err <> 0 THEN COALESCE (Movement_err.InvNumber, '' )  || ' - ' || COALESCE (Object_Unit_err.ValueData, '') ELSE Object_PartnerMedical.ValueData END :: TVarChar AS HospitalName

             , Object_Goods.ObjectCode             AS GoodsCode
             , Object_Goods.ValueData              AS GoodsName
             , tmpGoodsSP.IntenalSPName
             , tmpGoodsSP.BrandSPName
             , tmpGoodsSP.KindOutSPName
             , tmpGoodsSP.Pack  ::TVarChar
             , tmpGoodsSP.CountSP :: TFloat 
             , tmpGoodsSP.PriceSP :: TFloat 
             , tmpGoodsSP.GroupSP :: TFloat 

             , tmpGoodsSP.CodeATX         ::TVarChar
             , tmpGoodsSP.ReestrSP        ::TVarChar
             , tmpGoodsSP.MakerSP         ::TVarChar
             , tmpGoodsSP.DateReestrSP    ::TVarChar
             , tmpGoodsSP.PriceOptSP      :: TFloat
             , tmpGoodsSP.PriceRetSP      :: TFloat
             , tmpGoodsSP.DailyNormSP     :: TFloat
             , tmpGoodsSP.DailyCompensationSP  :: TFloat
             , tmpGoodsSP.PaymentSP       :: TFloat
             , tmpGoodsSP.ColSP           :: TFloat
             , tmpGoodsSP.InsertDateSP    :: TDateTime

             , tmpData.Amount            :: TFloat 
             , CAST (tmpData.PriceSale AS NUMERIC(16,2))                        :: TFloat 
             , CASE WHEN date_trunc('day', tmpData.OperDate) = ('01.06.2017' ::TDateTime)
                    THEN tmpData.Price_calc
                    ELSE CAST ((tmpData.SummChangePercent / tmpData.Amount) AS NUMERIC(16,2))
               END                                                              :: TFloat  AS PriceCheckSP
             , CASE WHEN date_trunc('day', tmpData.OperDate) = ('01.06.2017' ::TDateTime)
                    THEN CAST (tmpData.Price_calc * tmpData.Amount AS NUMERIC(16,2))
                    ELSE CAST (tmpData.SummChangePercent AS NUMERIC(16,2)) 
               END                                                              :: TFloat  AS SummaSP
             , CAST (ROW_NUMBER() OVER (PARTITION BY Object_PartnerMedical.Id ORDER BY tmpGoodsSP.IntenalSPName, tmpData.OperDate ) AS Integer) AS NumLine    --PARTITION BY Object_Juridical.ValueData
             , CAST (tmpCountR.CountInvNumberSP AS Integer) AS CountInvNumberSP

             , COALESCE (tmpParam.JuridicalFullName, Object_Juridical.ValueData ) :: TVarChar  AS JuridicalFullName
             , tmpParam.JuridicalAddress
             , tmpParam.OKPO
             , tmpParam.MainName
             , COALESCE (tmpParam.MainName_Cut, tmpParam.MainName) :: TVarChar  AS MainName_Cut
             , tmpParam.AccounterName
             , tmpParam.INN
             , tmpParam.NumberVAT
             , tmpParam.BankAccount
             , tmpParam.Phone
             , tmpParam.BankName ::TVarChar
             , tmpParam.MFO      ::TVarChar

             , COALESCE (tmpParam.PartnerMedical_FullName, Object_PartnerMedical.ValueData) :: TVarChar AS PartnerMedical_FullName
             , tmpParam.PartnerMedical_JuridicalAddress
             , tmpParam.PartnerMedical_OKPO  ::TVarChar
             , tmpParam.PartnerMedical_Phone
             , tmpParam.PartnerMedical_BankAccount ::TVarChar
             , tmpParam.PartnerMedical_BankName ::TVarChar
             , tmpParam.PartnerMedical_MFO      ::TVarChar
             , tmpParam.PartnerMedical_ContractId                                       AS ContractId
             , COALESCE (tmpParam.PartnerMedical_ContractName, '')         ::TVarChar   AS ContractName
             , (CASE WHEN COALESCE (tmpParam.PartnerMedical_Contract_StartDate, Null) <> '01.01.2100' THEN COALESCE (tmpParam.PartnerMedical_Contract_StartDate, Null) ELSE NULL END) :: TDateTime AS Contract_StartDate
             , COALESCE (tmpParam.PartnerMedical_Contract_SigningDate, Null) :: TDateTime AS Contract_SigningDate
            
             , tmpData.MedicSPName
             , tmpData.InvNumberSP
             , tmpData.OperDateSP
             , date_trunc('day', tmpData.OperDate)  :: TDateTime as OperDate

             , tmpData.InvNumber_Invoice
             , tmpData.InvNumber_Invoice_Full
             , tmpData.OperDate_Invoice
             
             , tmpInvoice.TotalSumm  :: TFloat AS TotalSumm_Invoice
        FROM tmpMI AS tmpData
             LEFT JOIN Movement AS Movement_err ON Movement_err.Id = tmpData.MovementId_err
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit_err
                                          ON MovementLinkObject_Unit_err.MovementId = tmpData.MovementId_err
                                         AND MovementLinkObject_Unit_err.DescId = zc_MovementLinkObject_Unit()
             LEFT JOIN Object AS Object_Unit_err ON Object_Unit_err.Id = MovementLinkObject_Unit_err.ObjectId

             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
             LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = tmpData.HospitalId

             LEFT JOIN tmpGoodsSP AS tmpGoodsSP ON tmpGoodsSP.GoodsMainId = tmpData.GoodsMainId

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsMainId

             LEFT JOIN tmpParam ON tmpParam.UnitId = tmpData.UnitId
                               AND tmpParam.JuridicalId = tmpData.JuridicalId
                               AND tmpParam.HospitalId = tmpData.HospitalId
                               AND tmpParam.PartnerMedical_Contract_StartDate <= tmpData.OperDate AND tmpParam.PartnerMedical_Contract_EndDate >= tmpData.OperDate

             LEFT JOIN tmpCountR ON tmpCountR.JuridicalId = tmpData.JuridicalId
                                AND tmpCountR.HospitalId = tmpData.HospitalId
                                AND COALESCE (tmpCountR.ContractId,0) = COALESCE (tmpParam.PartnerMedical_ContractId,0)
          
             LEFT JOIN tmpInvoice ON tmpInvoice.JuridicalId = tmpData.JuridicalId
                                 ANd tmpInvoice.HospitalId  = tmpData.HospitalId
        ORDER BY Object_Unit.ValueData 
               , Object_Juridical.ValueData
               , tmpGoodsSP.IntenalSPName
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 07.05.18         *
 14.02.18         * add Contract_SigningDate
 03.05.17         *
 17.04.17         *
 20.12.16         *
*/

-- ����
-- SELECT * FROM gpReport_Check_SP (inStartDate:= '01.04.2017',inEndDate:= '15.04.2017', inJuridicalId:= 0, inUnitId:= 0, inHospitalId:= 0, inSession := '3');
-- select * from gpReport_Check_SP(inStartDate := ('01.01.2017')::TDateTime , inEndDate := ('31.12.2017')::TDateTime , inJuridicalId := 0 , inUnitId := 0 , inHospitalId := 0 ,  inSession := '3');
--select * from gpReport_Check_SP(inStartDate := ('01.03.2018')::TDateTime , inEndDate := ('15.03.2018')::TDateTime , inJuridicalId := 393052 , inUnitId := 0 , inHospitalId := 4474509 ,  inSession := '3');