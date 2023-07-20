-- Function:  gpReport_Sale_SP()

--DROP FUNCTION IF EXISTS gpReport_Sale_SP (TDateTime, TDateTime, Integer,Integer,Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_Sale_SP (TDateTime, TDateTime, Integer,Integer,Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_Sale_SP (TDateTime, TDateTime, Integer,Integer,Integer, Integer, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Sale_SP (TDateTime, TDateTime, Integer,Integer,Integer, Integer, TFloat, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Sale_SP(
    IN inStartDate        TDateTime,  -- ���� ������
    IN inEndDate          TDateTime,  -- ���� ���������
    IN inJuridicalId      Integer  ,  -- ��.����
    IN inUnitId           Integer  ,  -- ������
    IN inHospitalId       Integer  ,  -- ��������
    IN inGroupMemberSPId  Integer  ,  -- ��������� ��������
    IN inPercentSP        TFloat   ,  -- % ������
    IN inisGroupMemberSP  Boolean  ,  -- ����� ��������� ��������� ��������
    IN inNDSKindId        Integer  ,  -- ���
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementId     Integer
             , MovementItemId Integer
             , UnitId         Integer
             , UnitName       TVarChar
             , Unit_Address   TVarChar
             , JuridicalId    Integer
             , JuridicalName  TVarChar
             , HospitalId     Integer
             , HospitalName   TVarChar
             , isListSP       Boolean
             , InvNumberSP    TVarChar
             , MedicSP        TVarChar
             , AmbulantClinicSP TVarChar
             , MemberSP       TVarChar
             , GroupMemberSPId Integer
             , GroupMemberSPName TVarChar
             , AddressSP      TVarChar
             , INNSP          TVarChar
             , PassportSP     TVarChar
             , OperDateSP     TDateTime
             , OperDate       TDateTime

             , GoodsCode      Integer
             , GoodsName      TVarChar
             , GoodsNameUkr   TVarChar
             , MeasureName    TVarChar
             , isResolution_224 Boolean

             , ChangePercent  TFloat
             , Amount         TFloat
             , PriceSP        TFloat
             , PriceOriginal  TFloat
             , PriceComp      TFloat

             , SummaSP        TFloat
             , SummOriginal   TFloat
             , SummaComp      TFloat
             , SummaCompWithOutVat TFloat
             , NumLine        Integer
             , CountSP        Integer

             , JuridicalFullName  TVarChar
             , JuridicalAddress   TVarChar
             , OKPO               TVarChar
             , AccounterName      TVarChar
             , INN                TVarChar
             , NumberVAT          TVarChar
             , BankAccount        TVarChar
             , Phone              TVarChar
             , MainName           TVarChar
             , Reestr             TVarChar
             , Decision           TVarChar
             , DecisionDate       TDateTime
             , License            TVarChar
             , BankName           TVarChar
             , MFO                TVarChar

             , PartnerMedical_JuridicalName    TVarChar
             , PartnerMedical_FullName         TVarChar
             , PartnerMedical_JuridicalAddress TVarChar
             , PartnerMedical_Phone            TVarChar

             , PartnerMedical_OKPO             TVarChar
             , PartnerMedical_AccounterName    TVarChar
             , PartnerMedical_INN              TVarChar
             , PartnerMedical_NumberVAT        TVarChar
             , PartnerMedical_BankAccount      TVarChar
             , PartnerMedical_BankName         TVarChar
             , PartnerMedical_MFO              TVarChar

             , MedicFIO TVarChar

             , ContractId             Integer
             , ContractName           TVarChar
             , Contract_StartDate     TDateTime
             , Contract_SigningDate   TDateTime
             , InvNumber_Invoice      TVarChar
             , InvNumber_Invoice_Full TVarChar
             
             , isPrintLast       Boolean
             
             --, OperDate_in TDateTime
             , InvNumber_in TVarChar
             , JuridicalName_in TVarChar
             , NDS_in TFloat
             , PriceWithOutVAT_in TFloat
             , SummWithOutVAT_in TFloat
             , ChargePersent_in TFloat
             , isManual Boolean
             
             , PriceOOC TFloat
             , SumCompOOC TFloat
             , DSummaSP TFloat
             , Color_DSummaSP Integer
             , isUsePriceOOC Boolean
             , PriceRegistryFull TFloat
             , SummaRegistryFull TFloat
             , PriceRegistry TFloat
             , SummaRegistry TFloat
             
             , IntenalSP_1303Id   Integer 
             , IntenalSP_1303Name TVarChar
             , BrandSPId     Integer 
             , BrandSPName   TVarChar
             , KindOutSP_1303Id   Integer 
             , KindOutSP_1303Name TVarChar
             , Dosage_1303Id   Integer 
             , Dosage_1303Name TVarChar             
             , CountSP_1303Id   Integer 
             , CountSP_1303Name TVarChar             
             , MakerCountrySP_1303Id   Integer 
             , MakerCountrySP_1303Name TVarChar             
             , PriceOptSP    TFloat
             
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);


    -- �������
    CREATE TEMP TABLE tmpUnit (UnitId Integer, JuridicalId Integer, Address TVarChar) ON COMMIT DROP;

    IF (COALESCE (inJuridicalId,0) <> 0) OR (COALESCE (inUnitId,0) <> 0) THEN
       INSERT INTO tmpUnit (UnitId, JuridicalId, Address)
                  SELECT OL_Unit_Juridical.ObjectId       AS UnitId
                       , OL_Unit_Juridical.ChildObjectId  AS JuridicalId
                       , ObjectString_Unit_Address.ValueData  AS Address
                  FROM ObjectLink AS OL_Unit_Juridical
                       LEFT JOIN ObjectString AS ObjectString_Unit_Address
                              ON ObjectString_Unit_Address.ObjectId = OL_Unit_Juridical.ObjectId
                             AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()
                  WHERE OL_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                    AND ((OL_Unit_Juridical.ChildObjectId = inJuridicalId AND COALESCE (inUnitId,0) = 0)
                          OR OL_Unit_Juridical.ObjectId = inUnitId);
    ELSE
       INSERT INTO tmpUnit (UnitId, JuridicalId, Address)
                  SELECT OL_Unit_Juridical.ObjectId AS UnitId
                       , OL_Unit_Juridical.ChildObjectId  AS JuridicalId
                       , ObjectString_Unit_Address.ValueData  AS Address
                  FROM ObjectLink AS OL_Unit_Juridical
                       LEFT JOIN ObjectString AS ObjectString_Unit_Address
                              ON ObjectString_Unit_Address.ObjectId = OL_Unit_Juridical.ObjectId
                             AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()
                  WHERE OL_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical();
    END IF;

    -- ���������
    RETURN QUERY
          WITH
          -- �������� ������� �� ������� ���.�������
          tmpSaleAll AS (SELECT Movement_Sale.Id
                              , Movement_Sale.DescId
                              , Movement_Sale.OperDate
                              , MovementLinkObject_Unit.ObjectId             AS UnitId
                              , tmpUnit.Address
                              , tmpUnit.JuridicalId                          AS JuridicalId
                              , MovementLinkObject_PartnerMedical.ObjectId   AS HospitalId
                              , COALESCE (MovementBoolean_List.ValueData, FALSE) AS isListSP
                              , MovementString_InvNumberSP.ValueData         AS InvNumberSP
                              , COALESCE (Object_MedicSP.ValueData, '')            :: TVarChar  AS MedicSP
                              , COALESCE (Object_AmbulantClinicSP.ValueData, '')   :: TVarChar  AS AmbulantClinicSP
                              , Object_MemberSP.Id                                     AS MemberSPId
                              , COALESCE (Object_MemberSP.ValueData, '')  :: TVarChar  AS MemberSP
                              , COALESCE (MovementDate_OperDateSP.ValueData,Null) AS OperDateSP
                              , MovementLinkObject_GroupMemberSP.ObjectId         AS GroupMemberSPId
                              , Movement_Invoice.InvNumber  :: TVarChar           AS InvNumber_Invoice
                              , ('� ' || Movement_Invoice.InvNumber || ' �� ' || Movement_Invoice.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Invoice_Full
                         FROM Movement AS Movement_Sale
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement_Sale.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                              INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                     ON MovementLinkObject_PartnerMedical.MovementId = Movement_Sale.Id
                                    AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()

                              LEFT JOIN MovementBoolean AS MovementBoolean_List
                                                        ON MovementBoolean_List.MovementId = Movement_Sale.Id
                                                       AND MovementBoolean_List.DescId     = zc_MovementBoolean_List()
                              LEFT JOIN MovementString AS MovementString_InvNumberSP
                                                       ON MovementString_InvNumberSP.MovementId = Movement_Sale.Id
                                                      AND MovementString_InvNumberSP.DescId     = zc_MovementString_InvNumberSP()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_MedicSP
                                     ON MovementLinkObject_MedicSP.MovementId = Movement_Sale.Id
                                    AND MovementLinkObject_MedicSP.DescId = zc_MovementLinkObject_MedicSP()
                              LEFT JOIN Object AS Object_MedicSP ON Object_MedicSP.Id = MovementLinkObject_MedicSP.ObjectId AND Object_MedicSP.DescId = zc_Object_MedicSP()

                              LEFT JOIN ObjectLink AS ObjectLink_MedicSP_AmbulantClinicSP
                                                   ON ObjectLink_MedicSP_AmbulantClinicSP.ObjectId = Object_MedicSP.Id
                                                  AND ObjectLink_MedicSP_AmbulantClinicSP.DescId = zc_ObjectLink_MedicSP_AmbulantClinicSP()
                              LEFT JOIN Object AS Object_AmbulantClinicSP ON Object_AmbulantClinicSP.Id = ObjectLink_MedicSP_AmbulantClinicSP.ChildObjectId

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberSP
                                     ON MovementLinkObject_MemberSP.MovementId = Movement_Sale.Id
                                    AND MovementLinkObject_MemberSP.DescId = zc_MovementLinkObject_MemberSP()
                              LEFT JOIN Object AS Object_MemberSP ON Object_MemberSP.Id = MovementLinkObject_MemberSP.ObjectId AND Object_MemberSP.DescId = zc_Object_MemberSP()

                              LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                                     ON MovementDate_OperDateSP.MovementId = Movement_Sale.Id
                                                    AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_GroupMemberSP
                                     ON MovementLinkObject_GroupMemberSP.MovementId = Movement_Sale.Id
                                    AND MovementLinkObject_GroupMemberSP.DescId = zc_MovementLinkObject_GroupMemberSP()

                              LEFT JOIN MovementLinkMovement AS MLM_Child
                                     ON MLM_Child.MovementId = Movement_Sale.Id
                                    AND MLM_Child.descId = zc_MovementLinkMovement_Child()
                              LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Child.MovementChildId

                         WHERE Movement_Sale.DescId = zc_Movement_Sale()
                           AND Movement_Sale.OperDate >= inStartDate AND Movement_Sale.OperDate < inEndDate + INTERVAL '1 DAY'
                           AND ( COALESCE (MovementLinkObject_PartnerMedical.ObjectId,0) <> 0 OR
                                 COALESCE (MovementLinkObject_GroupMemberSP.ObjectId ,0) <> 0 OR
                                 COALESCE (MovementString_InvNumberSP.ValueData,'') <> '' OR
                                 COALESCE (MovementLinkObject_MedicSP.ObjectId,0) <> 0 OR
                                 COALESCE (MovementLinkObject_MemberSP.ObjectId,0) <> 0
                               )
                           AND (MovementLinkObject_PartnerMedical.ObjectId = inHospitalId OR inHospitalId = 0)
                           AND (   (MovementLinkObject_GroupMemberSP.ObjectId =  inGroupMemberSPId AND inisGroupMemberSP = FALSE AND COALESCE(inGroupMemberSPId,0) <> 0)
                                OR (COALESCE(MovementLinkObject_GroupMemberSP.ObjectId,0) <> inGroupMemberSPId AND inisGroupMemberSP = TRUE AND COALESCE(inGroupMemberSPId,0) <> 0)
                                OR COALESCE(inGroupMemberSPId,0) = 0
                                )
                           AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                       UNION
                         SELECT Movement_Check.Id
                              , Movement_Check.DescId
                              , Movement_Check.OperDate
                              , MovementLinkObject_Unit.ObjectId             AS UnitId
                              , tmpUnit.Address
                              , tmpUnit.JuridicalId                          AS JuridicalId
                              , MovementLinkObject_PartnerMedical.ObjectId   AS HospitalId
                              , COALESCE (MovementBoolean_List.ValueData, FALSE) AS isListSP
                              , MovementString_InvNumberSP.ValueData         AS InvNumberSP
                              , COALESCE(Object_MedicKashtan.ValueData, MovementString_MedicSP.ValueData, ''):: TVarChar  AS MedicSP
                              , ''                                                 :: TVarChar  AS AmbulantClinicSP
                              , Object_MemberSP.Id                                                                     AS MemberSPId
                              , COALESCE (Object_MemberSP.ValueData, Object_MemberKashtan.ValueData, Object_BuyerForSite.ValueData, MovementString_Bayer.ValueData, '')  :: TVarChar  AS MemberSP
                              , COALESCE (MovementDate_OperDateSP.ValueData,Null) AS OperDateSP
                              , ObjectLink_MemberSP_GroupMemberSP.ChildObjectId   AS GroupMemberSPId
                              , Movement_Invoice.InvNumber  :: TVarChar           AS InvNumber_Invoice
                              , ('� ' || Movement_Invoice.InvNumber || ' �� ' || Movement_Invoice.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Invoice_Full
                         FROM Movement AS Movement_Check
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                              INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId

                              INNER JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                                            ON MovementLinkObject_SPKind.MovementId = Movement_Check.Id
                                                           AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                                                           AND MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_1303()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                                           ON MovementLinkObject_PartnerMedical.MovementId = Movement_Check.Id
                                                          AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()

                              LEFT JOIN MovementBoolean AS MovementBoolean_List
                                                        ON MovementBoolean_List.MovementId = Movement_Check.Id
                                                       AND MovementBoolean_List.DescId     = zc_MovementBoolean_List()
                              LEFT JOIN MovementString AS MovementString_InvNumberSP
                                                       ON MovementString_InvNumberSP.MovementId = Movement_Check.Id
                                                      AND MovementString_InvNumberSP.DescId     = zc_MovementString_InvNumberSP()

                              LEFT JOIN MovementString AS MovementString_MedicSP
                                                       ON MovementString_MedicSP.MovementId = Movement_Check.Id
                                                      AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()
                              LEFT JOIN MovementString AS MovementString_Bayer
                                                       ON MovementString_Bayer.MovementId = Movement_Check.Id
                                                      AND MovementString_Bayer.DescId = zc_MovementString_Bayer()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                                           ON MovementLinkObject_BuyerForSite.MovementId = Movement_Check.Id
                                                          AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
                              LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId

                              LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                                     ON MovementDate_OperDateSP.MovementId = Movement_Check.Id
                                                    AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()

                              LEFT JOIN MovementLinkMovement AS MLM_Child
                                                             ON MLM_Child.MovementId = Movement_Check.Id
                                                            AND MLM_Child.descId = zc_MovementLinkMovement_Child()
                              LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Child.MovementChildId

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberSP
                                                           ON MovementLinkObject_MemberSP.MovementId = Movement_Check.Id
                                                          AND MovementLinkObject_MemberSP.DescId = zc_MovementLinkObject_MemberSP()
                              LEFT JOIN Object AS Object_MemberSP ON Object_MemberSP.Id = MovementLinkObject_MemberSP.ObjectId

                              LEFT JOIN ObjectLink AS ObjectLink_MemberSP_GroupMemberSP
                                                   ON ObjectLink_MemberSP_GroupMemberSP.ObjectId = MovementLinkObject_MemberSP.ObjectId
                                                  AND ObjectLink_MemberSP_GroupMemberSP.DescId = zc_ObjectLink_MemberSP_GroupMemberSP()
                              LEFT JOIN Object AS Object_GroupMemberSP ON Object_GroupMemberSP.Id = ObjectLink_MemberSP_GroupMemberSP.ChildObjectId

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_MedicKashtan
                                                           ON MovementLinkObject_MedicKashtan.MovementId =  Movement_Check.Id
                                                          AND MovementLinkObject_MedicKashtan.DescId = zc_MovementLinkObject_MedicKashtan()
                              LEFT JOIN Object AS Object_MedicKashtan ON Object_MedicKashtan.Id = MovementLinkObject_MedicKashtan.ObjectId

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberKashtan
                                                           ON MovementLinkObject_MemberKashtan.MovementId =  Movement_Check.Id
                                                          AND MovementLinkObject_MemberKashtan.DescId = zc_MovementLinkObject_MemberKashtan()
                              LEFT JOIN Object AS Object_MemberKashtan ON Object_MemberKashtan.Id = MovementLinkObject_MemberKashtan.ObjectId

                         WHERE Movement_Check.DescId = zc_Movement_Check()
                           AND Movement_Check.OperDate >= inStartDate AND Movement_Check.OperDate < inEndDate + INTERVAL '1 DAY'
                           AND ( COALESCE (MovementLinkObject_PartnerMedical.ObjectId,0) <> 0 OR
                                 COALESCE (ObjectLink_MemberSP_GroupMemberSP.ChildObjectId ,0) <> 0 OR
                                 COALESCE (MovementString_InvNumberSP.ValueData,'') <> '' OR
                                 COALESCE (MovementString_MedicSP.ValueData, '') <> '' OR
                                 COALESCE (Object_BuyerForSite.ValueData, MovementString_Bayer.ValueData, '') <> ''
                               )
                           AND (MovementLinkObject_PartnerMedical.ObjectId = inHospitalId OR inHospitalId = 0)
                           AND (   (ObjectLink_MemberSP_GroupMemberSP.ChildObjectId = inGroupMemberSPId AND inisGroupMemberSP = FALSE AND COALESCE(inGroupMemberSPId,0) <> 0)
                                OR (COALESCE(ObjectLink_MemberSP_GroupMemberSP.ChildObjectId, 0) <> inGroupMemberSPId AND inisGroupMemberSP = TRUE AND COALESCE(inGroupMemberSPId,0) <> 0)
                                OR COALESCE(inGroupMemberSPId,0) = 0
                                )
                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                        )

            -- �������� ������� �� ������� ���.�������
            ,  tmpMI_Sum AS (SELECT Movement_Sale.Id   AS MovementId
                                  , Movement_Sale.OperDate
                                  , Movement_Sale.UnitId
                                  , Movement_Sale.JuridicalId
                                  , Movement_Sale.HospitalId
                                  , Movement_Sale.isListSP
                                  , Movement_Sale.InvNumberSP
                                  , Movement_Sale.MedicSP
                                  , Movement_Sale.AmbulantClinicSP
                                  , Movement_Sale.MemberSPId
                                  , Movement_Sale.MemberSP
                                  , Movement_Sale.OperDateSP
                                  , Movement_Sale.GroupMemberSPId
                                  , Movement_Sale.InvNumber_Invoice
                                  , Movement_Sale.InvNumber_Invoice_Full
                                  , MI_Sale.ObjectId                                          AS GoodsId         --tmpGoods.GoodsMainId                                      AS GoodsMainId
                                  , MIFloat_ChangePercent.ValueData                           AS ChangePercent
                                  , SUM (COALESCE (-1 * MIContainer.Amount, MI_Sale.Amount))  AS Amount
                                  , SUM (COALESCE (-1 * MIContainer.Amount, MI_Sale.Amount) * COALESCE (MIFloat_Price.ValueData, 0))     AS SummSale
                                  , SUM (COALESCE (-1 * MIContainer.Amount, MI_Sale.Amount) * COALESCE (MIFloat_PriceSale.ValueData, 0)) AS SummOriginal
                                  , MAX(MI_Sale.Id)::Integer                                  AS MovementItemId
                             FROM tmpSaleAll AS Movement_Sale
                                  INNER JOIN MovementItem AS MI_Sale
                                                          ON MI_Sale.MovementId = Movement_Sale.Id
                                                         AND MI_Sale.DescId = zc_MI_Master()
                                                         AND MI_Sale.isErased = FALSE
                                  LEFT JOIN MovementItemBoolean AS MIBoolean_SP
                                          ON MIBoolean_SP.MovementItemId = MI_Sale.Id
                                         AND MIBoolean_SP.DescId = zc_MIBoolean_SP()
                                         --AND MIBoolean_SP.ValueData = TRUE                        -- ���� ��������� � where , �,�. � ���� ��� ��-�� �� �����������
                                  LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                          ON MIFloat_ChangePercent.MovementItemId = MI_Sale.Id
                                         AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

                                  LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                         ON MIFloat_PriceSale.MovementItemId = MI_Sale.Id
                                        AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MI_Sale.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()

                                  LEFT JOIN MovementItemContainer AS MIContainer
                                                                  ON MIContainer.MovementItemId = MI_Sale.Id
                                                                 AND MIContainer.DescId = zc_MIContainer_Count()
                             WHERE (MIFloat_ChangePercent.ValueData = inPercentSP OR COALESCE (inPercentSP,0) = 0)
                               AND (MIBoolean_SP.ValueData = TRUE OR Movement_Sale.DescId = zc_Movement_Check())
                             GROUP BY Movement_Sale.Id
                                    , Movement_Sale.UnitId
                                    , Movement_Sale.JuridicalId
                                    , Movement_Sale.HospitalId
                                    , Movement_Sale.isListSP
                                    , Movement_Sale.InvNumberSP
                                    , Movement_Sale.MedicSP
                                    , Movement_Sale.AmbulantClinicSP
                                    , Movement_Sale.MemberSPId
                                    , Movement_Sale.MemberSP
                                    , Movement_Sale.OperDateSP
                                    , Movement_Sale.GroupMemberSPId
                                    , Movement_Sale.InvNumber_Invoice
                                    , Movement_Sale.InvNumber_Invoice_Full
                                    , MI_Sale.ObjectId
                                    , MIFloat_ChangePercent.ValueData
                                    , Movement_Sale.OperDate
                             HAVING SUM (COALESCE (-1 * MIContainer.Amount, MI_Sale.Amount)) <> 0
                            )
            -- �������� ������� �� ������� ���.�������
            ,  tmpMI AS (SELECT Movement_Sale.MovementId
                              , Movement_Sale.OperDate
                              , Movement_Sale.UnitId
                              , Movement_Sale.JuridicalId
                              , Movement_Sale.HospitalId
                              , Movement_Sale.isListSP
                              , Movement_Sale.InvNumberSP
                              , Movement_Sale.MedicSP
                              , Movement_Sale.AmbulantClinicSP
                              , Movement_Sale.MemberSPId
                              , Movement_Sale.MemberSP
                              , Movement_Sale.OperDateSP
                              , Movement_Sale.GroupMemberSPId
                              , Movement_Sale.InvNumber_Invoice
                              , Movement_Sale.InvNumber_Invoice_Full
                              , Movement_Sale.GoodsId 
                              , Movement_Sale.ChangePercent
                              , Movement_Sale.Amount
                              , Movement_Sale.SummSale
                              , Movement_Sale.SummOriginal
                              , Movement_Sale.MovementItemId
                              , COALESCE(MIBoolean_UsePriceOOC.ValueData, False)       AS isUsePriceOOC
                              , MIFloat_PriceSP.ValueData                              AS PriceRegistry
                         FROM tmpMI_Sum AS Movement_Sale
                              LEFT JOIN MovementItemBoolean AS MIBoolean_UsePriceOOC
                                                            ON MIBoolean_UsePriceOOC.MovementItemId = Movement_Sale.MovementItemId
                                                           AND MIBoolean_UsePriceOOC.DescId = zc_MIBoolean_UsePriceOOC()

                              LEFT JOIN MovementItemFloat AS MIFloat_PriceSP
                                                          ON MIFloat_PriceSP.MovementItemId = Movement_Sale.MovementItemId
                                                         AND MIFloat_PriceSP.DescId = zc_MIFloat_PriceSP()
                        )

                  -- �������� ���������, ��������� �� ������� % ������
           , tmpMov AS  (SELECT DISTINCT tmpMI.MovementId
                          FROM tmpMI
                          )
           , tmpSale AS (SELECT tmpSaleAll.*
                         FROM tmpSaleAll
                              INNER JOIN tmpMov ON tmpMov.MovementId = tmpSaleAll.Id
                         )
      , tmpBankAccount AS (SELECT tmp.JuridicalId
                                , MAX (tmp.Id) AS Id
                                , tmp.BankAccount
                                , tmp.BankName
                                , tmp.MFO
                           FROM (SELECT ObjectLink_Juridical.ChildObjectId AS JuridicalId
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
                                 UNION
                                 SELECT ObjectLink_Juridical.ChildObjectId AS JuridicalId
                                      , Object_BankAccount.Id
                                      , OS_BankAccount_CBAccount.ValueData AS BankAccount
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
                                    LEFT JOIN ObjectString AS OS_BankAccount_CBAccount
                                                           ON OS_BankAccount_CBAccount.ObjectId = Object_BankAccount.Id
                                                          AND OS_BankAccount_CBAccount.DescId = zc_ObjectString_BankAccount_CBAccount()
                                 WHERE Object_BankAccount.DescId = zc_object_BankAccount()
                                 ) AS tmp
                           GROUP BY tmp.JuridicalId
                                  , tmp.BankAccount
                                  , tmp.BankName
                                  , tmp.MFO
                           )
       -- �������� ��� ����������
       , tmpContract AS (SELECT ObjectLink_PartnerMedical_Juridical.ObjectId                  AS PartnerMedicalId
                              , ObjectLink_PartnerMedical_Juridical.ChildObjectId             AS PartnerMedical_JuridicalId
                              , COALESCE(ObjectLink_Contract_Juridical.ObjectId,0)            AS PartnerMedical_ContractId
                              , COALESCE(ObjectFloat_PercentSP.ValueData,0) :: TFloat         AS PercentSP
                              , COALESCE(ObjectLink_Contract_JuridicalBasis.ChildObjectId,0)  AS Contract_JuridicalBasisId
                              , COALESCE(ObjectLink_Contract_GroupMemberSP.ChildObjectId,0)   AS Contract_GroupMemberSPId

                              , ObjectDate_Signing.ValueData                                  AS SigningDate_Contract
                              , ObjectDate_Start.ValueData                                    AS StartDate_Contract
                              , ObjectDate_End.ValueData                                      AS EndDate_Contract

                         FROM ObjectLink AS ObjectLink_PartnerMedical_Juridical
                              LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                     ON ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_PartnerMedical_Juridical.ChildObjectId
                                    AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                              LEFT JOIN ObjectFloat AS ObjectFloat_PercentSP
                                     ON ObjectFloat_PercentSP.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                    AND ObjectFloat_PercentSP.DescId = zc_ObjectFloat_Contract_PercentSP()

                              LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                     ON ObjectLink_Contract_JuridicalBasis.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                    AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
                              LEFT JOIN ObjectLink AS ObjectLink_Contract_GroupMemberSP
                                     ON ObjectLink_Contract_GroupMemberSP.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                    AND ObjectLink_Contract_GroupMemberSP.DescId = zc_ObjectLink_Contract_GroupMemberSP()

                              LEFT JOIN ObjectDate AS ObjectDate_Start
                                                   ON ObjectDate_Start.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                                  AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
                              LEFT JOIN ObjectDate AS ObjectDate_End
                                                   ON ObjectDate_End.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                                  AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()
                              LEFT JOIN ObjectDate AS ObjectDate_Signing
                                                   ON ObjectDate_Signing.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                                  AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()

                         WHERE ObjectLink_PartnerMedical_Juridical.DescId = zc_ObjectLink_PartnerMedical_Juridical()
                           AND (( (COALESCE(ObjectLink_Contract_GroupMemberSP.ChildObjectId,0) = inGroupMemberSPId AND inisGroupMemberSP = FALSE AND COALESCE(inGroupMemberSPId,0) <> 0)
                              OR (COALESCE(ObjectLink_Contract_GroupMemberSP.ChildObjectId,0) = 0 AND inisGroupMemberSP = TRUE AND COALESCE(inGroupMemberSPId,0) <> 0)
                              OR COALESCE(inGroupMemberSPId,0) = 0
                               ) OR inEndDate > '01.01.2019')
                          -- AND ( ( (COALESCE (ObjectFloat_PercentSP.ValueData,0) = inPercentSP OR COALESCE (inPercentSP,0) = 0) ) OR inEndDate > '01.01.2019')
                        )
  
 , tmpSaleGroups AS (SELECT DISTINCT tmpSale.JuridicalId, ObjectLink_PartnerMedical_Juridical.ChildObjectId AS PartnerMedical_JuridicalId 
                     FROM tmpSale

                       LEFT JOIN ObjectLink AS ObjectLink_PartnerMedical_Juridical
                              ON ObjectLink_PartnerMedical_Juridical.ObjectId = tmpSale.HospitalId
                             AND ObjectLink_PartnerMedical_Juridical.DescId = zc_ObjectLink_PartnerMedical_Juridical())
 , tmpMovDetailsAll AS (SELECT 
                            tmpSaleGroups.JuridicalId                             AS JuridicalId
                          , tmpSaleGroups.PartnerMedical_JuridicalId              AS PartnerMedical_JuridicalId 

                          , ObjectHistory_JuridicalDetails.FullName AS JuridicalFullName
                          , ObjectHistory_JuridicalDetails.JuridicalAddress
                          , ObjectHistory_JuridicalDetails.OKPO
                          , ObjectHistory_JuridicalDetails.AccounterName
                          , ObjectHistory_JuridicalDetails.INN
                          , ObjectHistory_JuridicalDetails.NumberVAT
                          , ObjectHistory_JuridicalDetails.BankAccount
                          , ObjectHistory_JuridicalDetails.Phone

                          , ObjectHistory_JuridicalDetails.MainName
                          , ObjectHistory_JuridicalDetails.Reestr
                          , ObjectHistory_JuridicalDetails.Decision
                          , ObjectHistory_JuridicalDetails.DecisionDate
                          , ObjectHistory_JuridicalDetails.License

                          , ObjectHistory_PartnerMedicalDetails.FullName          AS PartnerMedical_FullName
                          , ObjectHistory_PartnerMedicalDetails.JuridicalAddress  AS PartnerMedical_JuridicalAddress
                          , ObjectHistory_PartnerMedicalDetails.Phone             AS PartnerMedical_Phone
                          , ObjectHistory_PartnerMedicalDetails.OKPO              AS PartnerMedical_OKPO
                          , ObjectHistory_PartnerMedicalDetails.AccounterName     AS PartnerMedical_AccounterName
                          , ObjectHistory_PartnerMedicalDetails.INN               AS PartnerMedical_INN
                          , ObjectHistory_PartnerMedicalDetails.NumberVAT         AS PartnerMedical_NumberVAT
                          , ObjectHistory_PartnerMedicalDetails.BankAccount       AS PartnerMedical_BankAccount

                     FROM tmpSaleGroups

                       LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := tmpSaleGroups.JuridicalId, inFullName := '', inOKPO := '', inSession := '3' /*inSession*/) AS ObjectHistory_JuridicalDetails ON 1=1
                       LEFT JOIN gpSelect_ObjectHistory_JuridicalDetails(injuridicalid := tmpSaleGroups.PartnerMedical_JuridicalId , inFullName := '', inOKPO := '', inSession := '3' /*inSession*/) AS ObjectHistory_PartnerMedicalDetails ON 1=1

                    )
                             
 , tmpMovDetails AS (SELECT tmpSale.Id   AS MovementId
                          , tmpSale.OperDate
                          , tmpSale.UnitId
                          , tmpSale.Address
                          , tmpSale.JuridicalId
                          , tmpSale.HospitalId
                          , tmpSale.isListSP
                          , tmpSale.InvNumberSP
                          , tmpSale.MedicSP
                          , tmpSale.AmbulantClinicSP
                          , tmpSale.MemberSP
                          , tmpSale.OperDateSP
                          , tmpSale.GroupMemberSPId

                          , tmpMovDetailsAll.JuridicalFullName
                          , tmpMovDetailsAll.JuridicalAddress
                          , tmpMovDetailsAll.OKPO
                          , tmpMovDetailsAll.AccounterName
                          , tmpMovDetailsAll.INN
                          , tmpMovDetailsAll.NumberVAT
                          , tmpMovDetailsAll.BankAccount
                          , tmpMovDetailsAll.Phone

                          , tmpMovDetailsAll.MainName
                          , tmpMovDetailsAll.Reestr
                          , tmpMovDetailsAll.Decision
                          , tmpMovDetailsAll.DecisionDate
                          , tmpMovDetailsAll.License

                          , tmpBankAccount.BankName ::TVarChar
                          , tmpBankAccount.MFO      ::TVarChar

                          , ObjectLink_PartnerMedical_Juridical.ChildObjectId     AS PartnerMedical_JuridicalId  --ObjectLink_PartnerMedical_Juridical.ChildObjectId     AS PartnerMedical_JuridicalId
                          , tmpMovDetailsAll.PartnerMedical_FullName
                          , tmpMovDetailsAll.PartnerMedical_JuridicalAddress
                          , tmpMovDetailsAll.PartnerMedical_Phone
                          , tmpMovDetailsAll.PartnerMedical_OKPO
                          , tmpMovDetailsAll.PartnerMedical_AccounterName
                          , tmpMovDetailsAll.PartnerMedical_INN
                          , tmpMovDetailsAll.PartnerMedical_NumberVAT
                          , COALESCE (Object_BankAccount.ValueData, tmpMovDetailsAll.BankAccount)                       AS PartnerMedical_BankAccount
                          , COALESCE (Object_Bank.ValueData,tmpPartnerMedicalBankAccount.BankName)                      AS PartnerMedical_BankName
                          , COALESCE (ObjectString_MFO.ValueData,tmpPartnerMedicalBankAccount.MFO)                      AS PartnerMedical_MFO
                          , ObjectString_PartnerMedical_FIO.ValueData             AS MedicFIO
                          , COALESCE (tmpContract.PartnerMedical_ContractId,0)    AS PartnerMedical_ContractId
                          , tmpContract.PercentSP
                          , tmpContract.StartDate_Contract
                          , tmpContract.SigningDate_Contract

                     FROM tmpSale
                       LEFT JOIN ObjectString AS ObjectString_PartnerMedical_FIO
                              ON ObjectString_PartnerMedical_FIO.ObjectId = tmpSale.HospitalId
                             AND ObjectString_PartnerMedical_FIO.DescId = zc_ObjectString_PartnerMedical_FIO()

                       LEFT JOIN ObjectLink AS ObjectLink_PartnerMedical_Juridical
                              ON ObjectLink_PartnerMedical_Juridical.ObjectId = tmpSale.HospitalId
                             AND ObjectLink_PartnerMedical_Juridical.DescId = zc_ObjectLink_PartnerMedical_Juridical()
                             
                       LEFT JOIN tmpMovDetailsAll ON tmpMovDetailsAll.JuridicalId = tmpSale.JuridicalId
                                                 AND tmpMovDetailsAll.PartnerMedical_JuridicalId = ObjectLink_PartnerMedical_Juridical.ChildObjectId

                       LEFT JOIN tmpBankAccount
                              ON tmpBankAccount.JuridicalId = tmpSale.JuridicalId
                             AND tmpBankAccount.BankAccount = tmpMovDetailsAll.BankAccount

                       LEFT JOIN tmpBankAccount AS tmpPartnerMedicalBankAccount
                              ON tmpPartnerMedicalBankAccount.JuridicalId = ObjectLink_PartnerMedical_Juridical.ChildObjectId  --ObjectLink_PartnerMedical_Juridical.ChildObjectId
                             AND tmpPartnerMedicalBankAccount.BankAccount = tmpMovDetailsAll.PartnerMedical_BankAccount

                       LEFT JOIN tmpContract ON tmpContract.PartnerMedicalId = tmpSale.HospitalId
                                            AND tmpContract.PartnerMedical_JuridicalId = ObjectLink_PartnerMedical_Juridical.ChildObjectId
                                            AND tmpContract.Contract_JuridicalBasisId = tmpSale.JuridicalId
                                            AND tmpContract.StartDate_Contract <= tmpSale.OperDate AND tmpContract.EndDate_Contract >= tmpSale.OperDate --�������� ���. �������� �����
                                            
                                           -- � 01,01,2019 ���� ������� ��� ��������� 
                                            AND (COALESCE (tmpContract.Contract_GroupMemberSPId,0) = CASE WHEN (COALESCE (tmpSale.GroupMemberSPId,0) = 4063780 AND COALESCE(inGroupMemberSPId,0) <> 0)
                                                                                                          THEN COALESCE (tmpSale.GroupMemberSPId,0)
                                                                                                         ELSE 0
                                                                                                    END                                             --4063780;6;"�������"  -- test 3690580
                                                OR inEndDate > '01.01.2019')
                  --                          AND COALESCE (tmpContract.PercentSP,0) = tmpSale.ChangePercent

                          -- ��������� ���� �� ��������
                          LEFT JOIN ObjectLink AS ObjectLink_Contract_BankAccount
                                 ON ObjectLink_Contract_BankAccount.ObjectId = tmpContract.PartnerMedical_ContractId
                                AND ObjectLink_Contract_BankAccount.DescId = zc_ObjectLink_Contract_BankAccount()
                          LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = ObjectLink_Contract_BankAccount.ChildObjectId
                          LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                 ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
                                AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
                          LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId
                          LEFT JOIN ObjectString AS ObjectString_MFO
                                 ON ObjectString_MFO.ObjectId = Object_Bank.Id
                                AND ObjectString_MFO.DescId = zc_ObjectString_Bank_MFO()


                    )

    , tmpCountR AS (SELECT  tmpMovDetails.JuridicalId
                          , tmpMovDetails.HospitalId
                          , tmpMovDetails.PartnerMedical_ContractId AS ContractId
                          , COUNT (DISTINCT (tmpMovDetails.InvNumberSP||'_'||tmpMovDetails.MedicSP)) AS CountSP
                    FROM tmpMovDetails
                    GROUP BY tmpMovDetails.JuridicalId
                           , tmpMovDetails.HospitalId
                           , tmpMovDetails.PartnerMedical_ContractId
                    )
    , tmpObjectString AS (SELECT ObjectString.*
                          FROM ObjectString
                          WHERE ObjectString.ObjectId IN (SELECT DISTINCT tmpMI.MemberSPId FROM tmpMI)
                            AND ObjectString.DescId IN (zc_ObjectString_MemberSP_Address()
                                                      , zc_ObjectString_MemberSP_INN()
                                                      , zc_ObjectString_MemberSP_Passport())
                          )
    -- ���������� �� ������
    , tmpMIC AS (SELECT MovementItemContainer.OperDate
                     , MovementItemContainer.ContainerId
                     , (-MovementItemContainer.Amount)::TFloat AS Amount
                     , MovementItemContainer.MovementId
                     , tmp.UnitId
                 FROM (SELECT DISTINCT tmpSaleAll.Id, tmpSaleAll.UnitId FROM tmpSaleAll) AS tmp
                       JOIN MovementItemContainer ON MovementItemContainer.MovementId = tmp.Id
                                                 AND MovementItemContainer.DescId = zc_MIContainer_Count()
                )
    , tmpMIC_Info AS (SELECT tmpMIC.MovementId
                           , tmpMIC.UnitId
                           , MI_Income.GoodsId
                           , SUM (tmpMIC.Amount) AS Amount
                           , SUM (tmpMIC.Amount * MI_Income.PriceWithVAT) AS SumWithVAT
                           , SUM (tmpMIC.Amount * CASE WHEN COALESCE(MovementBoolean_PriceWithVAT.ValueData,FALSE) = FALSE
                                                       THEN  MI_Income.Price
                                                       ELSE (MI_Income.Price / (1 + ObjectFloat_NDSKind_NDS.ValueData/100))::TFloat
                                                  END) ::TFloat AS SumWithOutVAT

                           , MAX (ObjectFloat_NDSKind_NDS.ValueData)     AS NDS
                           , STRING_AGG (DISTINCT Object_From.ValueData, ';') AS JuridicalName_in
                           , STRING_AGG (DISTINCT '� '||Movement_Income.InvNumber||' �� '||Movement_Income.OperDate::Date , ';') AS InvNumber_in
                           , MAX (CASE WHEN MovementLinkObject_NDSKind.ObjectId = zc_Enum_NDSKind_Common()
                                       THEN zc_Enum_NDSKind_Medical() 
                                       ELSE MovementLinkObject_NDSKind.ObjectId END) AS NDSKindId
                      FROM tmpMIC
                           LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                               ON CLI_MI.ContainerId = tmpMIC.ContainerId
                                                              AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                           LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                           LEFT OUTER JOIN MovementItem_Income_View AS MI_Income
                                                                    ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                           LEFT OUTER JOIN MovementLinkObject AS MLO_From
                                                              ON MLO_From.MovementId = MI_Income.MovementId
                                                             AND MLO_From.DescId = zc_MovementLinkObject_From()

                           LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                     ON MovementBoolean_PriceWithVAT.MovementId =  MI_Income.MovementId
                                                    AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                        ON MovementLinkObject_NDSKind.MovementId = MI_Income.MovementId
                                                       AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                                       AND (COALESCE (MovementLinkObject_NDSKind.ObjectId, 0) <> 13937605 OR
                                                            tmpMIC.OperDate < '01.07.2023')
                           LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                 ON ObjectFloat_NDSKind_NDS.ObjectId = CASE WHEN MovementLinkObject_NDSKind.ObjectId = zc_Enum_NDSKind_Common() THEN zc_Enum_NDSKind_Medical() ELSE MovementLinkObject_NDSKind.ObjectId END
                                                AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 
                           LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = MI_Income.MovementId 
                           LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
                        GROUP BY MI_Income.GoodsId
                               , COALESCE(MovementBoolean_PriceWithVAT.ValueData, FALSE)
                               , tmpMIC.MovementId
                               , tmpMIC.UnitId
                        )

    , tmpPrice AS (SELECT DISTINCT
                          CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                AND ObjectFloat_Goods_Price.ValueData > 0
                               THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                               ELSE ROUND (Price_Value.ValueData, 2)
                          END :: TFloat                           AS Price
                        , Price_Goods.ChildObjectId               AS GoodsId
                        , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                   FROM ObjectLink AS ObjectLink_Price_Unit
                      LEFT JOIN ObjectLink AS Price_Goods
                                           ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                          AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                      INNER JOIN tmpMIC_Info ON tmpMIC_Info.GoodsId = Price_Goods.ChildObjectId

                      LEFT JOIN ObjectFloat AS Price_Value
                                            ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                           AND Price_Value.DescId = zc_ObjectFloat_Price_Value()

                      -- ���� ���� ��� ���� ����
                      LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                             ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                            AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                      LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                              ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                             AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                   WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                     AND ObjectLink_Price_Unit.ChildObjectId IN (SELECT DISTINCT tmpUnit.UnitId FROM tmpUnit)
                   )

    , tmpPartionParam AS (SELECT tmpMIC_Info.MovementId
                               , tmpMIC_Info.UnitId
                               , tmpMIC_Info.GoodsId
                               , CASE WHEN tmpMIC_Info.Amount <> 0 THEN tmpMIC_Info.SumWithOutVAT / tmpMIC_Info.Amount ELSE 0 END PriceWithOutVAT
                               , tmpMIC_Info.JuridicalName_in
                               , tmpMIC_Info.NDS
                               , tmpMIC_Info.InvNumber_in
                               , CASE WHEN tmpMIC_Info.Amount <> 0 AND COALESCE (tmpMIC_Info.SumWithVAT,0) <> 0 
                                      THEN (tmpPrice.Price - (tmpMIC_Info.SumWithVAT/tmpMIC_Info.Amount) ) *100 / (tmpMIC_Info.SumWithVAT/tmpMIC_Info.Amount) 
                                      ELSE 0 END :: TFloat AS ChargePersent
                               , tmpMIC_Info.NDSKindId
                          FROM tmpMIC_Info
                                JOIN tmpPrice ON tmpPrice.GoodsId = tmpMIC_Info.GoodsId
                                                 AND tmpPrice.UnitId = tmpMIC_Info.UnitId
                         )

     , tmpGoodsMain AS (SELECT tmpGoods.GoodsId
                             , Object_Goods_Main.isResolution_224
                             , Object_Goods_Main.Id                 AS GoodsMainId
                        FROM (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI) AS tmpGoods
                             JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = tmpGoods.GoodsId 
                             JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                        )
     , tmpGoodsSPRegistry_1303 AS (select * from gpSelect_GoodsSPRegistry_1303_byDate(inStartDate := inStartDate, inEndDate := inEndDate, inSession := inSession))
     , tmpMILinkObject AS (SELECT * FROM MovementItemLinkObject
                           WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpGoodsSPRegistry_1303.MovementItemId FROM tmpGoodsSPRegistry_1303))

        -- ���������
        SELECT tmpData.MovementId
             , tmpData.MovementItemId
             , Object_Unit.Id                      AS UnitId
             , Object_Unit.ValueData               AS UnitName
             , tmpMovDetails.Address               AS Unit_Address
             , Object_Juridical.Id                 AS JuridicalId
             , Object_Juridical.ValueData          AS JuridicalName
             , Object_PartnerMedical.Id            AS HospitalId
             , Object_PartnerMedical.ValueData     AS HospitalName
             , tmpData.isListSP
             , tmpData.InvNumberSP
             , tmpData.MedicSP
             , tmpData.AmbulantClinicSP
             , tmpData.MemberSP
             , Object_GroupMemberSP.Id             AS GroupMemberSPId
             , COALESCE (Object_GroupMemberSP.ValueData, Object_Category1303.ValueData)  :: TVarChar  AS GroupMemberSPName
             , COALESCE (ObjectString_Address.ValueData, '')   :: TVarChar  AS AddressSP
             , COALESCE (ObjectString_INN.ValueData, '')       :: TVarChar  AS INNSP
             , COALESCE (ObjectString_Passport.ValueData, '')  :: TVarChar  AS PassportSP
          
             , tmpData.OperDateSP        :: TDateTime
             , tmpData.OperDate          :: TDateTime
             , Object_Goods_Main.ObjectCode        AS GoodsCode
             , Object_Goods_Main.Name              AS GoodsName
             , COALESCE(NULLIF(Object_Goods_Main.NameUkr, ''), Object_Goods_Main.Name) :: TVarChar AS GoodsNameUkr
             , Object_Measure.ValueData            AS MeasureName
             , tmpGoodsMain.isResolution_224 :: Boolean
             , tmpData.ChangePercent     :: TFloat
             , tmpData.Amount            :: TFloat

             , CAST ( (CASE WHEN tmpData.Amount <>0 THEN tmpData.SummSale/tmpData.Amount ELSE 0 END)  AS NUMERIC (16,2) )     :: TFloat  AS PriceSP
             , CAST ( (CASE WHEN tmpData.Amount <>0 THEN tmpData.SummOriginal/tmpData.Amount ELSE 0 END)  AS NUMERIC (16,2) ) :: TFloat  AS PriceOriginal
             , CAST ( (CASE WHEN tmpData.Amount <>0 THEN (tmpData.SummOriginal/tmpData.Amount - tmpData.SummSale/tmpData.Amount) ELSE 0 END)  AS NUMERIC (16,2) ) :: TFloat  AS PriceComp

             , tmpData.SummSale                                                    :: TFloat  AS SummaSP
             , CAST (tmpData.SummOriginal AS NUMERIC (16,2))                       :: TFloat  AS SummOriginal
             , CAST ((tmpData.SummOriginal - tmpData.SummSale) AS NUMERIC (16,2))  :: TFloat  AS SummaComp
             , CAST ((tmpData.SummOriginal - tmpData.SummSale) / (1 + COALESCE(tmpPartionParam.NDS, ObjectFloat_NDSKind_NDS.ValueData, 7) / 100) AS NUMERIC (16,2))  :: TFloat  AS SummaCompWithOutVat

             , CAST (ROW_NUMBER() OVER (PARTITION BY Object_PartnerMedical.ValueData, Object_Contract.Id   ORDER BY tmpData.OperDate, Object_Goods_Main.Name) AS Integer) AS NumLine
             , CAST (tmpCountR.CountSP AS Integer) AS CountSP

           , COALESCE (tmpMovDetails.JuridicalFullName,Object_Juridical.ValueData)
           , tmpMovDetails.JuridicalAddress
           , tmpMovDetails.OKPO
           , tmpMovDetails.AccounterName
           , tmpMovDetails.INN
           , tmpMovDetails.NumberVAT
           , CASE WHEN tmpMovDetails.JuridicalId = 2886776 
                  THEN 'UA083077700000026008711126473'  
                  WHEN tmpMovDetails.JuridicalId = 472115  
                  THEN 'UA443077700000026006711126475' 
                  WHEN tmpMovDetails.JuridicalId = 1311462 
                   AND Object_PartnerMedical.Id = 4474556 
                  THEN 'UA833077700000026002711126394' 
                  WHEN tmpMovDetails.JuridicalId = 3457711 
                   AND Object_PartnerMedical.Id = 4474556 
                  THEN 'UA313077700000026003711126326' 
                  WHEN tmpMovDetails.JuridicalId = 1311462  
                   AND Object_PartnerMedical.Id = 4212299 
                  THEN 'UA833077700000026002711126394' 
                  WHEN tmpMovDetails.JuridicalId = 393038   
                   AND Object_PartnerMedical.Id = 4474509  
                  THEN 'UA553223130000026001000030333' 
                  WHEN tmpMovDetails.JuridicalId = 6608394   
                   AND Object_PartnerMedical.Id = 3751525  
                  THEN 'UA493223130000026006000037643' 
                  ELSE tmpMovDetails.BankAccount END ::TVarChar
           , tmpMovDetails.Phone
           , tmpMovDetails.MainName
           , tmpMovDetails.Reestr
           , tmpMovDetails.Decision
           , tmpMovDetails.DecisionDate
           , tmpMovDetails.License
           , CASE WHEN tmpMovDetails.JuridicalId = 2886776 
                  THEN '�� "�_����"'  
                  WHEN tmpMovDetails.JuridicalId = 472115  
                  THEN '�� "�-����"' 
                  WHEN tmpMovDetails.JuridicalId = 1311462 
                   AND Object_PartnerMedical.Id = 4474556 
                  THEN '�� "�-����"' 
                  WHEN tmpMovDetails.JuridicalId = 3457711 
                   AND Object_PartnerMedical.Id = 4474556 
                  THEN '�� "�-����"' 
                  WHEN tmpMovDetails.JuridicalId = 1311462  
                   AND Object_PartnerMedical.Id = 4212299 
                  THEN '�� "�-����"' 
                  WHEN tmpMovDetails.JuridicalId = 393038   
                   AND Object_PartnerMedical.Id = 4474509  
                  THEN 'AT "�����������"' 
                  WHEN tmpMovDetails.JuridicalId = 6608394   
                   AND Object_PartnerMedical.Id = 3751525  
                  THEN '�� "�����������"' 
                  ELSE tmpMovDetails.BankName END ::TVarChar
           , CASE WHEN tmpMovDetails.JuridicalId = 2886776 
                  THEN '370770'  
                  WHEN tmpMovDetails.JuridicalId = 472115  
                  THEN '370770' 
                  WHEN tmpMovDetails.JuridicalId = 1311462 
                   AND Object_PartnerMedical.Id = 4474556 
                  THEN '307770' 
                  WHEN tmpMovDetails.JuridicalId = 3457711 
                   AND Object_PartnerMedical.Id = 4474556 
                  THEN '307770' 
                  WHEN tmpMovDetails.JuridicalId = 1311462  
                   AND Object_PartnerMedical.Id = 4212299 
                  THEN '307770' 
                  WHEN tmpMovDetails.JuridicalId = 393038   
                   AND Object_PartnerMedical.Id = 4474509  
                  THEN '322313' 
                  WHEN tmpMovDetails.JuridicalId = 6608394   
                   AND Object_PartnerMedical.Id = 3751525  
                  THEN '322313' 
                  ELSE tmpMovDetails.MFO END      ::TVarChar

           , Object_PartnerMedicalJuridical.ValueData AS PartnerMedical_JuridicalName
           , tmpMovDetails.PartnerMedical_FullName
           , tmpMovDetails.PartnerMedical_JuridicalAddress
           , tmpMovDetails.PartnerMedical_Phone
           , tmpMovDetails.PartnerMedical_OKPO
           , tmpMovDetails.PartnerMedical_AccounterName
           , tmpMovDetails.PartnerMedical_INN
           , tmpMovDetails.PartnerMedical_NumberVAT
           , tmpMovDetails.PartnerMedical_BankAccount
           , tmpMovDetails.PartnerMedical_BankName
           , tmpMovDetails.PartnerMedical_MFO
           , tmpMovDetails.MedicFIO
           , Object_Contract.Id                  AS ContractId
           , Object_Contract.ValueData :: TVarChar  AS ContractName
           , tmpMovDetails.StartDate_Contract    AS Contract_StartDate
           , CASE WHEN COALESCE (Object_Contract.ValueData, '') = '' THEN NULL ELSE tmpMovDetails.SigningDate_Contract END :: TDateTime AS Contract_SigningDate
           , tmpData.InvNumber_Invoice
           , tmpData.InvNumber_Invoice_Full
           
           , FALSE                                        AS isPrintLast
           
           , tmpPartionParam.InvNumber_in     ::TVarChar  AS InvNumber_in
           , tmpPartionParam.JuridicalName_in ::TVarChar  AS JuridicalName_in
           , COALESCE(tmpPartionParam.NDS, ObjectFloat_NDSKind_NDS.ValueData)::TFloat    AS NDS_in
           , tmpPartionParam.PriceWithOutVAT  ::TFloat    AS PriceWithOutVAT_in
           , (tmpPartionParam.PriceWithOutVAT * tmpData.Amount) ::TFloat AS SummWithOutVAT_in
           , tmpPartionParam.ChargePersent    ::TFloat    AS ChargePersent_in
           , COALESCE(MovementBoolean_Manual.ValueData, False)            AS isManual
           
           , tmpGoodsSPRegistry_1303.PriceSale :: TFloat                                                            AS PriceOOC
           , ROUND(tmpGoodsSPRegistry_1303.PriceSale * tmpData.Amount * tmpData.ChangePercent / 100.0, 2) :: TFloat AS SumCompOOC
                   
           , NULLIF(CAST ( (CASE WHEN tmpData.Amount <>0 THEN tmpData.SummOriginal/tmpData.Amount ELSE 0 END)  AS NUMERIC (16,2) ) :: TFloat - 
                  tmpGoodsSPRegistry_1303.PriceSale  , 0)::TFloat   AS DSummaSP
           , CASE WHEN COALESCE(tmpGoodsSPRegistry_1303.PriceSale, 0)= 0  THEN zfCalc_Color(255, 165, 0)
                  WHEN tmpData.isUsePriceOOC = TRUE AND
                       ROUND(tmpGoodsSPRegistry_1303.PriceSale * tmpData.Amount * tmpData.ChangePercent / 100.0, 2) :: TFloat >=
                       ROUND(tmpData.PriceRegistry * tmpData.Amount * tmpData.ChangePercent / 100.0, 2) :: TFloat THEN zfCalc_Color(135, 206, 235)
                  WHEN ROUND(tmpGoodsSPRegistry_1303.PriceSale * tmpData.Amount * tmpData.ChangePercent / 100.0, 2) :: TFloat < 
                       CAST ((tmpData.SummOriginal - tmpData.SummSale) AS NUMERIC (16,2))  :: TFloat  THEN zfCalc_Color(255, 182, 203)
                  WHEN ROUND(tmpGoodsSPRegistry_1303.PriceSale * tmpData.Amount * tmpData.ChangePercent / 100.0, 2) :: TFloat > 
                       CAST ((tmpData.SummOriginal - tmpData.SummSale) AS NUMERIC (16,2))  :: TFloat  THEN zfCalc_Color(152, 251, 152)
                  ELSE zc_Color_White() END::Integer Color_DSummaSP
           , tmpData.isUsePriceOOC
           
           , CASE WHEN tmpData.isUsePriceOOC = TRUE
                  THEN ROUND(tmpData.PriceRegistry, 2)
                  ELSE CAST ( (CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummOriginal/tmpData.Amount ELSE 0 END)  AS NUMERIC (16,2) ) END  :: TFloat  AS PriceRegistryFull
           , ROUND(CASE WHEN tmpData.isUsePriceOOC = TRUE
                        THEN tmpData.PriceRegistry * tmpData.Amount 
                        ELSE CAST ((tmpData.SummOriginal) AS NUMERIC (16,2)) END, 2)  :: TFloat  AS SummaRegistryFull

           , CASE WHEN tmpData.isUsePriceOOC = TRUE
                  THEN ROUND(tmpData.PriceRegistry * tmpData.ChangePercent / 100.0, 2)
                  ELSE CAST ( (CASE WHEN tmpData.Amount <> 0 THEN (tmpData.SummOriginal - tmpData.SummSale)/tmpData.Amount ELSE 0 END)  AS NUMERIC (16,2) ) END  :: TFloat  AS PriceRegistry
           , ROUND(CASE WHEN tmpData.isUsePriceOOC = TRUE
                        THEN tmpData.PriceRegistry * tmpData.Amount * tmpData.ChangePercent / 100.0
                        ELSE CAST ((tmpData.SummOriginal - tmpData.SummSale) AS NUMERIC (16,2)) END, 2)  :: TFloat  AS SummaRegistry
                        
                        
           , COALESCE (Object_IntenalSP_1303.Id ,0)          ::Integer  AS IntenalSP_1303Id
           , COALESCE (Object_IntenalSP_1303.ValueData,'')   ::TVarChar AS IntenalSP_1303Name
           , COALESCE (Object_BrandSP.Id ,0)            ::Integer  AS BrandSPId
           , COALESCE (Object_BrandSP.ValueData,'')     ::TVarChar AS BrandSPName
           , COALESCE (Object_KindOutSP_1303.Id ,0)          ::Integer  AS KindOutSP_1303Id
           , COALESCE (Object_KindOutSP_1303.ValueData,'')   ::TVarChar AS KindOutSP_1303Name
           , COALESCE (Object_Dosage_1303.Id ,0)          ::Integer  AS Dosage_1303Id
           , COALESCE (Object_Dosage_1303.ValueData,'')   ::TVarChar AS Dosage_1303Name
           , COALESCE (Object_CountSP_1303.Id ,0)          ::Integer  AS CountSP_1303Id
           , COALESCE (Object_CountSP_1303.ValueData,'')   ::TVarChar AS CountSP_1303Name
           , COALESCE (Object_MakerCountrySP_1303.Id ,0)          ::Integer  AS MakerCountrySP_1303Id
           , COALESCE (Object_MakerCountrySP_1303.ValueData,'')   ::TVarChar AS MakerCountrySP_1303Name
                        
           , tmpGoodsSPRegistry_1303.PriceOptSP                     AS PriceOptSP
                        
        FROM tmpMI AS tmpData
             LEFT JOIN tmpMovDetails ON tmpData.MovementId = tmpMovDetails.MovementId
                                  --  AND tmpData.ChangePercent = tmpMovDetails.PercentSP

             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId AND Object_Unit.DescId = zc_Object_Unit()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId AND Object_Juridical.DescId = zc_Object_Juridical()
             LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = tmpData.HospitalId  AND Object_PartnerMedical.DescId = zc_Object_PartnerMedical()
             LEFT JOIN Object AS Object_PartnerMedicalJuridical ON Object_PartnerMedicalJuridical.Id = tmpMovDetails.PartnerMedical_JuridicalId  AND Object_PartnerMedicalJuridical.DescId = zc_Object_PartnerMedical()
             LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpMovDetails.PartnerMedical_ContractId
                                                AND Object_Contract.DescId = zc_Object_Contract()

             LEFT JOIN Object AS Object_GroupMemberSP ON Object_GroupMemberSP.Id = tmpData.GroupMemberSPId AND Object_GroupMemberSP.DescId = zc_Object_GroupMemberSP()
             --LEFT JOIN Object AS Object_MemberSP ON Object_MemberSP.Id = tmpData.MemberSPId AND Object_MemberSP.DescId = zc_Object_MemberSP()
             --LEFT JOIN Object AS Object_MedicSP ON Object_MedicSP.Id = tmpData.MedicSPId AND Object_MedicSP.DescId = zc_Object_MedicSP()

             LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = tmpData.GoodsId
             LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
             
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = tmpData.GoodsId
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
             LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = Object_Goods_Main.NDSKindId
             LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                   ON ObjectFloat_NDSKind_NDS.ObjectId = Object_NDSKind.Id
                                  AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()


             LEFT JOIN tmpCountR ON tmpCountR.JuridicalId = tmpData.JuridicalId
                                AND tmpCountR.HospitalId = tmpData.HospitalId
                                AND tmpCountR.ContractId = tmpMovDetails.PartnerMedical_ContractId

             LEFT JOIN tmpObjectString AS ObjectString_Address
                                       ON ObjectString_Address.ObjectId = tmpData.MemberSPId
                                      AND ObjectString_Address.DescId = zc_ObjectString_MemberSP_Address()
             LEFT JOIN tmpObjectString AS ObjectString_INN
                                       ON ObjectString_INN.ObjectId = tmpData.MemberSPId
                                      AND ObjectString_INN.DescId = zc_ObjectString_MemberSP_INN()
             LEFT JOIN tmpObjectString AS ObjectString_Passport
                                       ON ObjectString_Passport.ObjectId = tmpData.MemberSPId
                                      AND ObjectString_Passport.DescId = zc_ObjectString_MemberSP_Passport()

             LEFT JOIN tmpPartionParam ON tmpPartionParam.MovementId = tmpData.MovementId
                                      AND tmpPartionParam.GoodsId = tmpData.GoodsId
             
             LEFT JOIN tmpGoodsMain ON tmpGoodsMain.GoodsId = tmpData.GoodsId

             LEFT JOIN MovementBoolean AS MovementBoolean_Manual
                                       ON MovementBoolean_Manual.MovementId = tmpData.MovementId
                                      AND MovementBoolean_Manual.DescId = zc_MovementBoolean_Manual()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Category1303
                                          ON MovementLinkObject_Category1303.MovementId =  tmpData.MovementId
                                         AND MovementLinkObject_Category1303.DescId = zc_MovementLinkObject_Category1303()
             LEFT JOIN Object AS Object_Category1303 ON Object_Category1303.Id = MovementLinkObject_Category1303.ObjectId
            
             LEFT JOIN tmpGoodsSPRegistry_1303 ON tmpGoodsSPRegistry_1303.DateStart <= date_trunc('DAY', tmpData.OperDate)
                                              AND tmpGoodsSPRegistry_1303.DateEnd >= date_trunc('DAY', tmpData.OperDate)
                                              AND tmpGoodsSPRegistry_1303.GoodsId = tmpGoodsMain.GoodsMainId

             LEFT JOIN tmpMILinkObject AS MI_IntenalSP_1303
                                              ON MI_IntenalSP_1303.MovementItemId = tmpGoodsSPRegistry_1303.MovementItemId
                                             AND MI_IntenalSP_1303.DescId = zc_MILinkObject_IntenalSP_1303()
             LEFT JOIN Object AS Object_IntenalSP_1303 ON Object_IntenalSP_1303.Id = MI_IntenalSP_1303.ObjectId 

             LEFT JOIN tmpMILinkObject AS MI_BrandSP
                                              ON MI_BrandSP.MovementItemId = tmpGoodsSPRegistry_1303.MovementItemId
                                             AND MI_BrandSP.DescId = zc_MILinkObject_BrandSP()
             LEFT JOIN Object AS Object_BrandSP ON Object_BrandSP.Id = MI_BrandSP.ObjectId 

             LEFT JOIN tmpMILinkObject AS MI_KindOutSP_1303
                                              ON MI_KindOutSP_1303.MovementItemId = tmpGoodsSPRegistry_1303.MovementItemId
                                             AND MI_KindOutSP_1303.DescId = zc_MILinkObject_KindOutSP_1303()
             LEFT JOIN Object AS Object_KindOutSP_1303 ON Object_KindOutSP_1303.Id = MI_KindOutSP_1303.ObjectId 

             LEFT JOIN tmpMILinkObject AS MI_Dosage_1303
                                              ON MI_Dosage_1303.MovementItemId = tmpGoodsSPRegistry_1303.MovementItemId
                                             AND MI_Dosage_1303.DescId = zc_MILinkObject_Dosage_1303()
             LEFT JOIN Object AS Object_Dosage_1303 ON Object_Dosage_1303.Id = MI_Dosage_1303.ObjectId 

             LEFT JOIN tmpMILinkObject AS MI_CountSP_1303
                                              ON MI_CountSP_1303.MovementItemId = tmpGoodsSPRegistry_1303.MovementItemId
                                             AND MI_CountSP_1303.DescId = zc_MILinkObject_CountSP_1303()
             LEFT JOIN Object AS Object_CountSP_1303 ON Object_CountSP_1303.Id = MI_CountSP_1303.ObjectId 

             LEFT JOIN tmpMILinkObject AS MI_MakerCountrySP_1303
                                              ON MI_MakerCountrySP_1303.MovementItemId = tmpGoodsSPRegistry_1303.MovementItemId
                                             AND MI_MakerCountrySP_1303.DescId = zc_MILinkObject_MakerCountrySP_1303()
             LEFT JOIN Object AS Object_MakerCountrySP_1303 ON Object_MakerCountrySP_1303.Id = MI_MakerCountrySP_1303.ObjectId 

        WHERE COALESCE(inNDSKindId, 0) = 0 OR COALESCE(tmpPartionParam.NDSKindId, Object_Goods_Main.NDSKindId) = inNDSKindId
         ORDER BY Object_Unit.ValueData 
                , Object_PartnerMedical.ValueData
                , ContractName
                , Object_Goods_Main.Name
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.   ������ �.�.
 21.04.21                                                                        * add BuyerForSite
 25.01.21                                                                        *
 26.11.19         *
 11.01.19         *
 05.06.18         *
 14.02.18         * add SigningDate_Contract
 24.05.17         * add zc_Movement_Check
 10.02.17         *
*/

-- ����

-- SELECT * FROM gpReport_Sale_SP (inStartDate:= '01.05.2022', inEndDate:= '05.05.2022', inJuridicalId:= 0, inUnitId:= 0, inHospitalId:= 0, inGroupMemberSPId:= 0, inPercentSP:= 0, inisGroupMemberSP:= TRUE, inNDSKindId := 0, inSession:= zfCalc_UserAdmin());

-- select * from gpReport_Sale_SP(inStartDate := ('01.08.2022')::TDateTime , inEndDate := ('12.08.2022')::TDateTime , inJuridicalId := 2886776 , inUnitId := 0 , inHospitalId := 0 , inGroupMemberSPId := 0 , inPercentSP := 0 , inisGroupMemberSP := 'False' , inNDSKindId := 9 ,  inSession := '3');


select * from gpReport_Sale_SP(inStartDate := ('01.07.2023')::TDateTime , inEndDate := ('15.07.2023')::TDateTime , inJuridicalId := 0 , inUnitId := 0 , inHospitalId := 0 , inGroupMemberSPId := 0 , inPercentSP := 0 , inisGroupMemberSP := 'False' , inNDSKindId := 13937605 ,  inSession := '3');

