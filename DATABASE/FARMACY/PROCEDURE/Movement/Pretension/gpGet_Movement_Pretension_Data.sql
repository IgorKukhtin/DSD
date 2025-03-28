-- Function: gpGet_Movement_Pretension_Data()

DROP FUNCTION IF EXISTS gpGet_Movement_Pretension_Data (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Pretension_Data(
    IN inMovementId    Integer  , -- ���� ���������
   OUT outDataAct      TBlob    , -- ������ 
    IN inSession       TVarChar   -- ������ ������������
)
RETURNS TBlob
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbComment TBlob;
    DECLARE vbDataGoods TBlob;

BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Pretension());
    vbUserId:= inSession;

    WITH tmpObjectHistory AS (SELECT *
                              FROM ObjectHistory
                              WHERE ObjectHistory.DescId = zc_ObjectHistory_JuridicalDetails()
                                AND ObjectHistory.enddate::timestamp with time zone = zc_dateend()::timestamp with time zone
                              )
      , tmpJuridicalDetails AS (SELECT ObjectHistory_JuridicalDetails.ObjectId                                        AS JuridicalId
                                  , COALESCE(ObjectHistory_JuridicalDetails.StartDate, zc_DateStart())             AS StartDate
                                  , ObjectHistoryString_JuridicalDetails_FullName.ValueData                        AS FullName
                                  , ObjectHistoryString_JuridicalDetails_JuridicalAddress.ValueData                AS JuridicalAddress
                                  , ObjectHistoryString_JuridicalDetails_OKPO.ValueData                            AS OKPO
                                  , ObjectHistoryString_JuridicalDetails_INN.ValueData                             AS INN
                                  , ObjectHistoryString_JuridicalDetails_NumberVAT.ValueData                       AS NumberVAT
                                  , ObjectHistoryString_JuridicalDetails_AccounterName.ValueData                   AS AccounterName
                                  , ObjectHistoryString_JuridicalDetails_BankAccount.ValueData                     AS BankAccount
                                  , ObjectHistoryString_JuridicalDetails_Phone.ValueData                           AS Phone
                       
                                  , ObjectHistoryString_JuridicalDetails_MainName.ValueData                        AS MainName
                                  , ObjectHistoryString_JuridicalDetails_MainName_Cut.ValueData                    AS MainName_Cut
                                  , ObjectHistoryString_JuridicalDetails_Reestr.ValueData                          AS Reestr
                                  , ObjectHistoryString_JuridicalDetails_Decision.ValueData                        AS Decision
                                  , ObjectHistoryString_JuridicalDetails_License.ValueData                         AS License
                                  , ObjectHistoryDate_JuridicalDetails_Decision.ValueData                          AS DecisionDate
                       
                             FROM tmpObjectHistory AS ObjectHistory_JuridicalDetails
                                  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_FullName
                                         ON ObjectHistoryString_JuridicalDetails_FullName.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                        AND ObjectHistoryString_JuridicalDetails_FullName.DescId = zc_ObjectHistoryString_JuridicalDetails_FullName()
                                  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_JuridicalAddress
                                         ON ObjectHistoryString_JuridicalDetails_JuridicalAddress.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                        AND ObjectHistoryString_JuridicalDetails_JuridicalAddress.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()
                                  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
                                         ON ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                        AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
                                  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_INN
                                         ON ObjectHistoryString_JuridicalDetails_INN.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                        AND ObjectHistoryString_JuridicalDetails_INN.DescId = zc_ObjectHistoryString_JuridicalDetails_INN()
                                  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_NumberVAT
                                         ON ObjectHistoryString_JuridicalDetails_NumberVAT.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                        AND ObjectHistoryString_JuridicalDetails_NumberVAT.DescId = zc_ObjectHistoryString_JuridicalDetails_NumberVAT()
                                  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_AccounterName
                                         ON ObjectHistoryString_JuridicalDetails_AccounterName.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                        AND ObjectHistoryString_JuridicalDetails_AccounterName.DescId = zc_ObjectHistoryString_JuridicalDetails_AccounterName()
                                  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_BankAccount
                                         ON ObjectHistoryString_JuridicalDetails_BankAccount.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                        AND ObjectHistoryString_JuridicalDetails_BankAccount.DescId = zc_ObjectHistoryString_JuridicalDetails_BankAccount()
                                  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_Phone
                                         ON ObjectHistoryString_JuridicalDetails_Phone.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                        AND ObjectHistoryString_JuridicalDetails_Phone.DescId = zc_ObjectHistoryString_JuridicalDetails_Phone()
                                
                                  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_MainName
                                         ON ObjectHistoryString_JuridicalDetails_MainName.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                        AND ObjectHistoryString_JuridicalDetails_MainName.DescId = zc_ObjectHistoryString_JuridicalDetails_MainName()
                                  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_MainName_Cut
                                         ON ObjectHistoryString_JuridicalDetails_MainName_Cut.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                        AND ObjectHistoryString_JuridicalDetails_MainName_Cut.DescId = zc_ObjectHistoryString_JuridicalDetails_MainName_Cut()
                                
                                  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_Reestr
                                         ON ObjectHistoryString_JuridicalDetails_Reestr.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                        AND ObjectHistoryString_JuridicalDetails_Reestr.DescId = zc_ObjectHistoryString_JuridicalDetails_Reestr()
                                  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_Decision
                                         ON ObjectHistoryString_JuridicalDetails_Decision.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                        AND ObjectHistoryString_JuridicalDetails_Decision.DescId = zc_ObjectHistoryString_JuridicalDetails_Decision()
                                
                                  LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_License
                                         ON ObjectHistoryString_JuridicalDetails_License.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                        AND ObjectHistoryString_JuridicalDetails_License.DescId = zc_ObjectHistoryString_JuridicalDetails_License()
                                
                                  LEFT JOIN ObjectHistoryDate AS ObjectHistoryDate_JuridicalDetails_Decision
                                         ON ObjectHistoryDate_JuridicalDetails_Decision.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                        AND ObjectHistoryDate_JuridicalDetails_Decision.DescId = zc_ObjectHistoryDate_JuridicalDetails_Decision()
                             )
                             
      SELECT
             Movement_Pretension_View.JuridicalName||Chr(13)||
             Movement_Pretension_View.FromName||Chr(13)||
             '���. '||ObjectString_Unit_Phone.ValueData||Chr(13)||
             '��������� �' ||Movement_Pretension_View.IncomeInvNumber||' �� '||TO_CHAR (Movement_Pretension_View.IncomeOperDate, 'dd.mm.yyyy')
           , Movement_Pretension_View.Comment  
       INTO outDataAct, vbComment
       FROM Movement_Pretension_View       

            LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                   ON ObjectString_Unit_Address.ObjectId = Movement_Pretension_View.FromId
                                  AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()
            LEFT JOIN ObjectString AS ObjectString_Unit_Phone
                                   ON ObjectString_Unit_Phone.ObjectId = Movement_Pretension_View.FromId
                                  AND ObjectString_Unit_Phone.DescId = zc_ObjectString_Unit_Phone()
            LEFT JOIN ObjectString AS ObjectString_PharmacyManager
                                   ON ObjectString_PharmacyManager.ObjectId = Movement_Pretension_View.FromId
                                  AND ObjectString_PharmacyManager.DescId = zc_ObjectString_Unit_PharmacyManager()
                                  
            LEFT JOIN ObjectDate AS ObjectDate_MondayStart
                                 ON ObjectDate_MondayStart.ObjectId = Movement_Pretension_View.FromId
                                AND ObjectDate_MondayStart.DescId = zc_ObjectDate_Unit_MondayStart()
            LEFT JOIN ObjectDate AS ObjectDate_MondayEnd
                                 ON ObjectDate_MondayEnd.ObjectId = Movement_Pretension_View.FromId
                                AND ObjectDate_MondayEnd.DescId = zc_ObjectDate_Unit_MondayEnd()
            LEFT JOIN ObjectDate AS ObjectDate_SaturdayStart
                                 ON ObjectDate_SaturdayStart.ObjectId = Movement_Pretension_View.FromId
                                AND ObjectDate_SaturdayStart.DescId = zc_ObjectDate_Unit_SaturdayStart()
            LEFT JOIN ObjectDate AS ObjectDate_SaturdayEnd
                                 ON ObjectDate_SaturdayEnd.ObjectId = Movement_Pretension_View.FromId
                                AND ObjectDate_SaturdayEnd.DescId = zc_ObjectDate_Unit_SaturdayEnd()
            LEFT JOIN ObjectDate AS ObjectDate_SundayStart
                                 ON ObjectDate_SundayStart.ObjectId = Movement_Pretension_View.FromId
                                AND ObjectDate_SundayStart.DescId = zc_ObjectDate_Unit_SundayStart()
            LEFT JOIN ObjectDate AS ObjectDate_SundayEnd 
                                 ON ObjectDate_SundayEnd.ObjectId = Movement_Pretension_View.FromId
                                AND ObjectDate_SundayEnd.DescId = zc_ObjectDate_Unit_SundayEnd()
            LEFT JOIN ObjectDate AS ObjectDate_FirstCheck
                                 ON ObjectDate_FirstCheck.ObjectId = Movement_Pretension_View.FromId
                                AND ObjectDate_FirstCheck.DescId = zc_ObjectDate_Unit_FirstCheck()

            LEFT JOIN tmpJuridicalDetails ON tmpJuridicalDetails.JuridicalId = Movement_Pretension_View.JuridicalId
            LEFT JOIN tmpJuridicalDetails AS JuridicalDetailsTo
                                          ON JuridicalDetailsTo.JuridicalId = Movement_Pretension_View.ToId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement_Pretension_View.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement_Pretension_View.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
                                        AND MLO_Insert.ObjectId <> 3
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId  

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = Object_Insert.ID
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
            
            
            LEFT JOIN Object AS Object_User ON Object_User.Id = vbUserId 
                                           AND Object_User.Id <> 3

            LEFT JOIN ObjectLink AS ObjectLink_User_MemberUser
                                 ON ObjectLink_User_MemberUser.ObjectId = Object_User.ID
                                AND ObjectLink_User_MemberUser.DescId = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_MemberUser ON Object_MemberUser.Id = ObjectLink_User_MemberUser.ChildObjectId
            LEFT JOIN ObjectString AS ObjectString_Member_Phone
                                   ON ObjectString_Member_Phone.ObjectId = Object_MemberUser.Id
                                  AND ObjectString_Member_Phone.DescId = zc_ObjectString_Member_Phone()
                                  
       WHERE Movement_Pretension_View.Id = inMovementId;
    
        SELECT string_agg(COALESCE(Object_PartnerGoods.Name, Object_Goods.ValueData, '')||
                          COALESCE(', '||Object_PartnerGoods.MakerName, '')||' '||
                          zfConvert_FloatToString(MI_Pretension.Amount)||' '||COALESCE(Object_ReasonDifferences.ValueData, ''), Chr(13))
        INTO vbDataGoods
        FROM Movement AS Movement_Pretension
             INNER JOIN MovementItem AS MI_Pretension
                                     ON MI_Pretension.MovementId = Movement_Pretension.Id
                                    AND MI_Pretension.isErased = FALSE
                                    AND MI_Pretension.DescId     = zc_MI_Master()
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Pretension.ObjectId

             LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                         ON MIFloat_MovementItemId.MovementItemId = MI_Pretension.Id
                                        AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
             LEFT JOIN MovementItemFloat AS MIFloat_Amount
                                         ON MIFloat_Amount.MovementItemId = MI_Pretension.Id
                                        AND MIFloat_Amount.DescId = zc_MIFloat_Amount()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                         ON MIFloat_AmountManual.MovementItemId = MI_Pretension.Id
                                        AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()

             LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                           ON MIBoolean_Checked.MovementItemId = MI_Pretension.Id
                                          AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                              ON MILinkObject_ReasonDifferences.MovementItemId = MI_Pretension.Id
                                             AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()
             LEFT JOIN Object AS Object_ReasonDifferences ON Object_ReasonDifferences.Id = MILinkObject_ReasonDifferences.ObjectId
             
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                              ON MILinkObject_Goods.MovementItemId = MIFloat_MovementItemId.ValueData::Integer
                                             AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
             LEFT JOIN Object_Goods_Juridical AS Object_PartnerGoods ON Object_PartnerGoods.Id = MILinkObject_Goods.ObjectId
             
        WHERE Movement_Pretension.Id = inMovementId
          AND MIBoolean_Checked.ValueData = True;
          
          
    IF COALESCE (vbDataGoods, '') <> ''
    THEN 
      outDataAct := outDataAct||Chr(13)||Chr(13)||vbDataGoods;
    END IF;

    IF COALESCE (vbComment, '') <> ''
    THEN 
      outDataAct := outDataAct||Chr(13)||Chr(13)||'�����������: '||vbComment;
    END IF;
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Pretension_Data (Integer,TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.12.21                                                       *
*/


select * from gpGet_Movement_Pretension_Data(inMovementId := 26008006 ,  inSession := '3');