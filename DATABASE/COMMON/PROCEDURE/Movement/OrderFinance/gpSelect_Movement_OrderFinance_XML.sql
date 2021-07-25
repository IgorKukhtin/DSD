-- Function:  gpSelect_Movement_OrderFinance_XML()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderFinance_XML (Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpSelect_Movement_OrderFinance_XML(
    IN inMovementId   Integer  ,  -- �������������
    IN inSession                  TVarChar    -- ������ ������������
)
RETURNS TABLE (RowData TBlob)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMemberId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     --       RAISE EXCEPTION '������.��� ���. ���� <%> ����� ��������� �� ��������� �� ������������� ����� ��������� �� �����������.', lfGet_Object_ValueData (vbMemberId);

    vbUserId:= lpGetUserBySession (inSession);

  CREATE TEMP TABLE tmpData (DOCUMENTDATE TVarChar, DOCUMENTNO TVarChar
                           , BANKID TVarChar, IBAN TVarChar, CORRBANKID TVarChar, CORRIBAN TVarChar
                           , CORRSNAME TVarChar, CORRIDENTIFYCODE TVarChar, DETAILSOFPAYMENT TVarChar
                           , AMOUNT INTEGER
                           , CORRCOUNTRYID TVarChar, PRIORITY TVarChar, PURPOSEPAYMENTID TVarChar, ADDENTRIES TVarChar, VALUEDATE TVarChar
                           ) ON COMMIT DROP;
     INSERT INTO tmpData (DOCUMENTDATE, DOCUMENTNO, BANKID, IBAN, CORRBANKID, CORRIBAN, CORRSNAME,  CORRIDENTIFYCODE, DETAILSOFPAYMENT, AMOUNT
                        , CORRCOUNTRYID, PRIORITY, PURPOSEPAYMENTID, ADDENTRIES, VALUEDATE)
      WITH
          tmpMovement AS (SELECT Movement.Id
                               , Movement.Invnumber
                               , Movement.OperDate
                               , Object_BankAccount_View.MFO
                               , Object_BankAccount_View.Name        AS BankAccountName
                               , OrderFinance_PaidKind.ChildObjectId AS PaidKindId

                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_BankAccount
                                                            ON MovementLinkObject_BankAccount.MovementId = Movement.Id
                                                           AND MovementLinkObject_BankAccount.DescId = zc_MovementLinkObject_BankAccount()
                               LEFT JOIN Object_BankAccount_View ON Object_BankAccount_View.Id = MovementLinkObject_BankAccount.ObjectId

                               LEFT JOIN MovementLinkObject ON MovementLinkObject.MovementId = inMovementId
                                                           AND MovementLinkObject.DescId = zc_MovementLinkObject_OrderFinance()
                               LEFT JOIN ObjectLink AS OrderFinance_PaidKind
                                                    ON OrderFinance_PaidKind.ObjectId = MovementLinkObject.ObjectId
                                                   AND OrderFinance_PaidKind.DescId = zc_ObjectLink_OrderFinance_PaidKind()
                          WHERE Movement.DescId = zc_Movement_OrderFinance()
                            AND Movement.Id = inMovementId
                         )

        , tmpMI AS (SELECT MovementItem.MovementId
                         , MovementItem.Id       AS MI_Id
                         , MovementItem.ObjectId AS JuridicalId
                         , MovementItem.Amount   AS Amount
                    FROM MovementItem
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId = zc_MI_Master()
                      AND MovementItem.isErased = False
                      AND COALESCE (MovementItem.Amount, 0) <> 0
                    )                         

        SELECT (lpad (EXTRACT (YEAR FROM tmpMovement.OperDate)::tvarchar ,4, '0')||lpad (EXTRACT (MONTH FROM tmpMovement.OperDate)::tvarchar ,2, '0') ||lpad (EXTRACT (DAY FROM tmpMovement.OperDate)::tvarchar ,2, '0')) ::TVarchar AS DOCUMENTDATE     --���� ���������
             , tmpMovement.Invnumber            AS DOCUMENTNO
             , tmpMovement.MFO                  AS BANKID
             , tmpMovement.BankAccountName      AS IBAN
             --, Object_BankAccount_View.BankName AS BankName_to
             , Object_BankAccount_View.MFO      AS CORRBANKID
             , Object_BankAccount_View.Name     AS CORRIBAN
             , Object_To.ValueData              AS CORRSNAME
             , COALESCE (ObjectHistory_JuridicalDetails_View.OKPO,'') :: TVarChar AS CORRIDENTIFYCODE
             --, Object_InfoMoney.ValueData       AS DETAILSOFPAYMENT
             , COALESCE (MIString_Comment.ValueData, Object_InfoMoney.ValueData) ::TVarChar AS DETAILSOFPAYMENT
             , (COALESCE (tmpMI.Amount,0) *100) :: INTEGER AS AMOUNT
             , 804                  ::TVarChar  AS CORRCOUNTRYID    --��� ������ ��������������
             , 50                   ::TVarChar  AS PRIORITY         --���������
             , '000'                ::TVarChar  AS PURPOSEPAYMENTID --��� ���������� �������
             , ''                   ::TVarChar  AS ADDENTRIES       --�������������� ��������� �������
             , (lpad (EXTRACT (YEAR FROM tmpMovement.OperDate)::tvarchar ,4, '0')||lpad (EXTRACT (MONTH FROM tmpMovement.OperDate)::tvarchar ,2, '0') ||lpad (EXTRACT (DAY FROM tmpMovement.OperDate)::tvarchar ,2, '0')) ::TVarchar AS VALUEDATE        --���� �������������
             
        FROM tmpMovement
             LEFT JOIN tmpMI ON tmpMI.MovementId = tmpMovement.Id
             LEFT JOIN MovementItemLinkObject AS MILinkObject_BankAccount
                                              ON MILinkObject_BankAccount.MovementItemId = tmpMI.MI_Id
                                             AND MILinkObject_BankAccount.DescId = zc_MILinkObject_BankAccount()
             LEFT JOIN Object_BankAccount_View ON Object_BankAccount_View.Id = MILinkObject_BankAccount.ObjectId
             
             LEFT JOIN Object AS Object_To ON Object_To.Id = tmpMI.JuridicalId
             -- ���� ��. ����
             LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = tmpMI.JuridicalId

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = tmpMI.MI_Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = tmpMI.MI_Id
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId

            INNER JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                  ON ObjectLink_Contract_PaidKind.ObjectId = Object_Contract.Id
                                 AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
                                 --AND ObjectLink_Contract_PaidKind.ChildObjectId = tmpMovement.PaidKindId

            LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                 ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                                AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId

            ;

 
     -- ������� ��� ����������
     CREATE TEMP TABLE _Result (Num Integer, RowData TBlob) ON COMMIT DROP;

     -- ������ ������� XML
     INSERT INTO _Result(Num, RowData) VALUES (1, '<?xml version= "1.0" encoding= "windows-1251"?>');
     
     -- ������
     INSERT INTO _Result(Num, RowData) VALUES (2, '<ROWDATA>');
     INSERT INTO _Result(Num, RowData)
    SELECT ROW_NUMBER() OVER (ORDER BY tmp.CORRSNAME ASC) + 100
          , '<ROW '
         || 'AMOUNT ="'||tmp.AMOUNT||'" '                                               --����� ������� � ��������                         
         --|| 'CORRSNAME="'||COALESCE (tmp.CORRSNAME,'')::TVarChar||'" '                  -- ������������ ���������� �������                 
         || 'CORRSNAME="'|| replace (replace (substring (COALESCE (tmp.CORRSNAME,''), 1, 36), '"', '&quot;'), CHR (39), '&apos;') :: TVarChar||'" ' -- ������������ ���������� ������� �������� , ���� ������ 36 ��������
         || 'DETAILSOFPAYMENT="'|| replace (replace (COALESCE (tmp.DETAILSOFPAYMENT,''), '"', '&quot;'), CHR (39), '&apos;')::TVarChar||'" '    --���������� �������                               
         || 'CORRACCOUNTNO="'||COALESCE (tmp.CORRIBAN,'')::TVarChar||'" '               --� ����� ���������� �������                       
         || 'CORRIBAN="'||COALESCE (tmp.CORRIBAN,'')::TVarChar||'" '                    --IBAN ���������� �������                          
         || 'ACCOUNTNO="'||COALESCE (tmp.IBAN,'')::TVarChar||'" '                       --� ����� �����������                              
         || 'IBAN="'||COALESCE (tmp.IBAN,'')::TVarChar||'" '                            --IBAN �����������                                 
         || 'CORRBANKID="'||COALESCE (tmp.CORRBANKID,'')::TVarChar||'" '                --��� ����� ���������� ������� (���)               
         || 'CORRIDENTIFYCODE="'||COALESCE (tmp.CORRIDENTIFYCODE,'')::TVarChar||'" '    --����������������� ��� ���������� ������� (������)
         || 'CORRCOUNTRYID="'||COALESCE (tmp.CORRCOUNTRYID,'')::TVarChar||'" '          --��� ������ ��������������                        
         --|| 'DOCUMENTNO="'||COALESCE (tmp.DOCUMENTNO,'')::TVarChar||'" '                --� ���������                                      
         || 'DOCUMENTNO="'||CAST (NEXTVAL ('movement_bankaccount_plat_seq') AS TVarChar)||'" '
       --|| 'VALUEDATE="'||COALESCE (tmp.VALUEDATE::TVarChar,'')::TVarChar||'" '        --���� �������������                               
         || 'PRIORITY="'||tmp.PRIORITY||'" '                                            --���������                                        
         || 'DOCUMENTDATE="'||tmp.DOCUMENTDATE||'" '                                    --���� ���������                                   
         || 'ADDENTRIES="'||COALESCE (tmp.ADDENTRIES,'')::TVarChar||'" '                --�������������� ��������� �������                 
         || 'PURPOSEPAYMENTID="'||COALESCE (tmp.PURPOSEPAYMENTID,'')||'" '              --��� ���������� �������   --??????????????????????
         || 'BANKID="'||COALESCE (tmp.BANKID,'')::TVarChar||'" '                        --��� ����� ����������� (���)                      
         || '/>'
     FROM tmpData AS tmp ;

     --��������� ������� XML
     INSERT INTO _Result(Num, RowData) VALUES ((SELECT MAX (_Result.Num) + 1 FROM _Result), '</ROWDATA>');

     -- ���������
     RETURN QUERY
        SELECT _Result.RowData FROM _Result ORDER BY Num;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�. 
 10.09.20         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_OrderFinance_XML(inMovementId :=19727298 , inSession := '3');
