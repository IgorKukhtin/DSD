-- Function: gpSelect_Object_GlobalMsg()

DROP FUNCTION IF EXISTS gpSelect_Object_GlobalMsg (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GlobalMsg(
    IN inIP          TVarChar,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (MovementId Integer, NPP Integer, MsgAddr TVarChar, MsgText TVarChar, ColorText_Addr Integer, Color_Addr Integer, ColorText_Text Integer, Color_Text Integer)
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsMsg_PromoStateKind Boolean;
   DECLARE vbIsMsg_Contract       Boolean;
   DECLARE vbIsUserSigning1       Boolean;
   DECLARE vbIsUserSigning2       Boolean;
   DECLARE vbIsMsgColor           Boolean;
   DECLARE vbMovementId_1_Head    Integer;
   DECLARE vbCount_1_Head         Integer;
   DECLARE vbMovementId_2_Head    Integer;
   DECLARE vbCount_2_Head         Integer;
   DECLARE vbMovementId_1_Main    Integer;
   DECLARE vbCount_1_Main         Integer;
   DECLARE vbMovementId_2_Main    Integer;
   DECLARE vbCount_2_Main         Integer;

   DECLARE vbCount_Contract       Integer;
   DECLARE vbOperDate_Contract    TDateTime;
   DECLARE vbOperDate_Contract_start TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());
     vbUserId:= lpGetUserBySession (inSession);


     -- zc_Enum_Role_Admin + ����� ��������� + ��������� - ������������
     vbIsMsg_PromoStateKind:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS UserRole_View WHERE UserRole_View.RoleId IN (zc_Enum_Role_Admin(), 876016, 5473256) AND UserRole_View.UserId = vbUserId);
     -- ��������-���� ������������
     vbIsMsg_Contract:= vbUserId = zfCalc_UserAdmin() :: Integer OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS UserRole_View WHERE UserRole_View.RoleId IN (78432) AND UserRole_View.UserId = vbUserId);

     --
     IF vbIsMsg_Contract = TRUE
     THEN
         -- ����������� �����
         vbIsMsg_Contract:= vbUserId = zfCalc_UserAdmin() :: Integer
                         OR EXISTS (SELECT 1
                                    FROM ObjectLink AS ObjectLink_User_Member
                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                              ON ObjectLink_Personal_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                             AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                         INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                               ON ObjectLink_Personal_Unit.ObjectId      = ObjectLink_Personal_Member.ObjectId
                                                              AND ObjectLink_Personal_Unit.DescId        = zc_ObjectLink_Personal_Unit()
                                                              AND ObjectLink_Personal_Unit.ChildObjectId = 8387
                                    WHERE ObjectLink_User_Member.ObjectId = vbUserId
                                      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                   );
         -- ���� ���� ����� ��������
         IF vbIsMsg_Contract = TRUE
         THEN
             -- ����
             vbOperDate_Contract:= DATE_TRUNC ('MONTH', CURRENT_DATE + INTERVAL '25 DAY') + INTERVAL '1 MONTH' - INTERVAL '1 DAY';
             vbOperDate_Contract_start:= DATE_TRUNC ('MONTH', vbOperDate_Contract) - INTERVAL '1 MONTH';
             -- ���-��
             vbCount_Contract:= COALESCE (
                                (SELECT COUNT (*)
                                 FROM ObjectDate AS ObjectDate_End
                                      INNER JOIN Object AS Object_Contract ON Object_Contract.Id        = ObjectDate_End.ObjectId
                                                                          AND Object_Contract.ValueData <> '-'
                                                                          AND Object_Contract.isErased  = FALSE
                                      INNER JOIN ObjectLink AS ObjectLink_ContractStateKind
                                                            ON ObjectLink_ContractStateKind.ObjectId      = Object_Contract.Id
                                                           AND ObjectLink_ContractStateKind.DescId        = zc_ObjectLink_Contract_ContractStateKind()
                                                           AND ObjectLink_ContractStateKind.ChildObjectId <> zc_Enum_ContractStateKind_Close()
                                      -- ���� ����������� ���������
                                      LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTermKind
                                                           ON ObjectLink_Contract_ContractTermKind.ObjectId = Object_Contract.Id
                                                          AND ObjectLink_Contract_ContractTermKind.DescId   = zc_ObjectLink_Contract_ContractTermKind()
                                      LEFT JOIN ObjectFloat AS ObjectFloat_Term
                                                            ON ObjectFloat_Term.ObjectId  = Object_Contract.Id
                                                           AND ObjectFloat_Term.DescId    = zc_ObjectFloat_Contract_Term()
                                                           AND ObjectFloat_Term.ValueData > 0
                                 WHERE ObjectDate_End.ValueData BETWEEN vbOperDate_Contract_start AND vbOperDate_Contract
                                   AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()
                                   AND (ObjectLink_Contract_ContractTermKind.ChildObjectId IS NULL
                                     OR ObjectFloat_Term.ObjectId IS NULL
                                       )
                                ), 0)

                              + COALESCE (
                                (SELECT COUNT (*)
                                 FROM -- ���� ����������� ���������
                                      ObjectLink AS ObjectLink_Contract_ContractTermKind
                                      INNER JOIN Object AS Object_Contract ON Object_Contract.Id        = ObjectLink_Contract_ContractTermKind.ObjectId
                                                                          AND Object_Contract.ValueData <> '-'
                                                                          AND Object_Contract.isErased  = FALSE
                                      INNER JOIN ObjectFloat AS ObjectFloat_Term
                                                             ON ObjectFloat_Term.ObjectId  = Object_Contract.Id
                                                            AND ObjectFloat_Term.DescId    = zc_ObjectFloat_Contract_Term()
                                                            AND ObjectFloat_Term.ValueData > 0
                                      INNER JOIN ObjectLink AS ObjectLink_ContractStateKind
                                                            ON ObjectLink_ContractStateKind.ObjectId      = Object_Contract.Id
                                                           AND ObjectLink_ContractStateKind.DescId        = zc_ObjectLink_Contract_ContractStateKind()
                                                           AND ObjectLink_ContractStateKind.ChildObjectId <> zc_Enum_ContractStateKind_Close()
                                      INNER JOIN ObjectDate AS ObjectDate_End
                                                            ON ObjectDate_End.ObjectId = Object_Contract.Id
                                                           AND ObjectDate_End.DescId   = zc_ObjectDate_Contract_End()
                                                           AND ObjectDate_End.ValueData + ((ObjectFloat_Term.ValueData :: Integer) :: TVarChar || ' MONTH') :: INTERVAL BETWEEN vbOperDate_Contract_start AND vbOperDate_Contract
                                 WHERE ObjectLink_Contract_ContractTermKind.ChildObjectId IN (zc_Enum_ContractTermKind_Month(), zc_Enum_ContractTermKind_Long())
                                   AND ObjectLink_Contract_ContractTermKind.DescId        = zc_ObjectLink_Contract_ContractTermKind()
                                )

       , CASE WHEN ObjectLink_Contract_ContractTermKind.ChildObjectId = zc_Enum_ContractTermKind_Long()
                   THEN ObjectDate_End.ValueData + ((ObjectFloat_Term.ValueData :: Integer) :: TVarChar || ' MONTH') :: INTERVAL
              WHEN ObjectLink_Contract_ContractTermKind.ChildObjectId = zc_Enum_ContractTermKind_Month() AND ObjectFloat_Term.ValueData > 0
                   THEN ObjectDate_End.ValueData + ((ObjectFloat_Term.ValueData :: Integer) :: TVarChar || ' MONTH') :: INTERVAL
              ELSE ObjectDate_End.ValueData
         END :: TDateTime AS EndDate_Term

                                , 0);
         END IF;
     END IF;

     -- Signing
     vbIsUserSigning1:= vbUserId IN (280164, 5, 133035);  -- ��������� �.�. + ������ �.�.
     vbIsUserSigning2:= vbUserId IN (9463); -- ������ �.�.
     -- vbIsUserSigning1:= vbUserId IN (133035, 5); -- ������ �.�.
     -- vbIsUserSigning2:= vbUserId IN (280164); -- ��������� �.�.

     -- ����� ���������
     vbIsMsgColor:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS UserRole_View WHERE UserRole_View.RoleId IN (876016) AND UserRole_View.UserId = vbUserId);

     -- ����� ���������
     IF 1=1 AND (vbIsMsg_PromoStateKind = TRUE OR vbIsMsg_Contract = TRUE)
     THEN
          SELECT
                 -- 1.1.1. MovementId - ������ - �������� �� ����������
                 MIN (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Head()
                            AND MovementFloat_PromoStateKind.ValueData     = 1
                                THEN Movement_Promo.Id
                                ELSE 2147483000
                      END) AS MovementId_1_Head
                 -- 1.1.2. Count - ������ - �������� �� ����������
               , SUM (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Head()
                            AND MovementFloat_PromoStateKind.ValueData     = 1
                                THEN 1
                                ELSE 0
                      END) AS Count_1_Head
                 -- 1.2.1. MovementId - �� ������ - �������� �� ����������
               , MIN (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Head()
                            AND COALESCE (MovementFloat_PromoStateKind.ValueData, 0) <> 1
                                THEN Movement_Promo.Id
                                ELSE 2147483000
                      END) AS MovementId_2_Head
                 -- 1.2.2. Count - �� ������ - �������� �� ����������
               , SUM (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Head()
                            AND COALESCE (MovementFloat_PromoStateKind.ValueData, 0) <> 1
                                THEN 1
                                ELSE 0
                      END) AS Count_2_Head


                 -- 2.1.1. MovementId - ������ - �������������� ��������
               , MIN (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Main()
                            AND MovementFloat_PromoStateKind.ValueData     = 1
                                THEN Movement_Promo.Id
                                ELSE 2147483000
                      END) AS MovementId_1_Main
                 -- 2.1.2. Count - ������ - �������������� ��������
               , SUM (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Main()
                            AND MovementFloat_PromoStateKind.ValueData     = 1
                                THEN 1
                                ELSE 0
                      END) AS Count_1_Main

                 -- 2.2.1. MovementId - �� ������ - �������������� ��������
               , MIN (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Main()
                            AND COALESCE (MovementFloat_PromoStateKind.ValueData, 0) <> 1
                                THEN Movement_Promo.Id
                                ELSE 2147483000
                      END) AS MovementId_2_Main
                 -- 2.2.2. Count - �� ������ - �������������� ��������
               , SUM (CASE WHEN MovementLinkObject_PromoStateKind.ObjectId = zc_Enum_PromoStateKind_Main()
                            AND COALESCE (MovementFloat_PromoStateKind.ValueData, 0) <> 1
                                THEN 1
                                ELSE 0
                      END) AS Count_2_Main


                 INTO vbMovementId_1_Head
                    , vbCount_1_Head
                    , vbMovementId_2_Head
                    , vbCount_2_Head
                    , vbMovementId_1_Main
                    , vbCount_1_Main
                    , vbMovementId_2_Main
                    , vbCount_2_Main

          FROM Movement AS Movement_Promo
               -- � ������ �������� �� ���������� + � ������ �������������� ��������
               INNER JOIN MovementLinkObject AS MovementLinkObject_PromoStateKind
                                             ON MovementLinkObject_PromoStateKind.MovementId = Movement_Promo.Id
                                            AND MovementLinkObject_PromoStateKind.DescId     = zc_MovementLinkObject_PromoStateKind()
                                            AND MovementLinkObject_PromoStateKind.ObjectId   IN (zc_Enum_PromoStateKind_Head(), zc_Enum_PromoStateKind_Main())
               -- ������
               LEFT JOIN MovementFloat AS MovementFloat_PromoStateKind
                                       ON MovementFloat_PromoStateKind.MovementId = Movement_Promo.Id
                                      AND MovementFloat_PromoStateKind.DescId     = zc_MovementFloat_PromoStateKind()
               LEFT JOIN MovementDate AS MovementDate_StartSale
                                      ON MovementDate_StartSale.MovementId = Movement_Promo.Id
                                     AND MovementDate_StartSale.DescId     = zc_MovementDate_StartSale()
          WHERE Movement_Promo.DescId   = zc_Movement_Promo()
          --AND Movement_Promo.StatusId = zc_Enum_Status_UnComplete()
            AND Movement_Promo.StatusId <> zc_Enum_Status_Erased()
            AND Movement_Promo.OperDate BETWEEN CURRENT_DATE - INTERVAL '5 MONTH' AND CURRENT_DATE + INTERVAL '25 MONTH'
            AND MovementDate_StartSale.ValueData >= CURRENT_DATE - INTERVAL '7 DAY'
            AND (Movement_Promo.Id <> 16390310 OR vbUserId = 5)
         ;
     END IF;


     -- ���������
     RETURN QUERY
       -- 1.1.
       SELECT CASE WHEN vbCount_1_Head > 0
                        THEN vbMovementId_1_Head
                   WHEN vbCount_2_Head > 0
                        THEN vbMovementId_2_Head
                   ELSE -1
              END :: Integer AS MovementId

            , CASE WHEN vbIsUserSigning2 = TRUE THEN 3 ELSE 1 END :: Integer AS NPP
            , '��������� �� ���������� : ' :: TVarChar AS MsgAddr

            , (CASE WHEN vbCount_1_Head > 0
                        THEN '������������ ���������� ��� ���������� '
                          || ' : '    || vbCount_1_Head :: TVarChar || ' ��.'
                          || COALESCE ((SELECT ' <' || MIS.ValueData || '>' FROM MovementItem AS MI JOIN MovementItemString AS MIS ON MIS.MovementItemId = MI.Id AND MIS.DescId = zc_MIString_Comment() AND MIS.ValueData <> '' WHERE MI.MovementId = vbMovementId_1_Head AND MI.DescId = zc_MI_Message() AND MI.ObjectId = zc_Enum_PromoStateKind_Head() AND MI.isErased = FALSE ORDER BY MI.Id DESC LIMIT 1), '')
                          || '    � ' || (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_1_Head)
                          || ' �� '   || zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_1_Head))
                          || ' ������ ������ � ' || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_1_Head AND MD.DescId = zc_MovementDate_StartSale()))
                          || ' �� '              || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_1_Head AND MD.DescId = zc_MovementDate_EndSale()))
                    ELSE '��� ������������ ����������'
               END :: TVarChar
              ) :: TVarChar AS ValueText

              -- 1.1.
            , CASE WHEN vbCount_1_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Black()
                   WHEN vbCount_2_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Addr
              -- 1.2.
            , CASE WHEN vbCount_1_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Yelow()
                   WHEN vbCount_2_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Pink()
                   ELSE -1
              END AS Color_Addr
              -- 2.1.
            , CASE WHEN vbCount_1_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Text
              -- 2.2.
            , CASE WHEN vbCount_1_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Yelow()
                   ELSE -1
              END AS Color_Text

      UNION ALL
       -- 1.2.
       SELECT CASE WHEN vbCount_2_Head > 0
                        THEN vbMovementId_2_Head
                   ELSE -1
              END :: Integer AS MovementId

            , CASE WHEN vbIsUserSigning2 = TRUE THEN 4 ELSE 2 END :: Integer AS NPP
            , '' :: TVarChar AS MsgAddr
            , (CASE WHEN vbCount_2_Head > 0
                        THEN '������������ ��������� ��� ���������� '
                          || ' : '    || vbCount_2_Head :: TVarChar || ' ��.'
                          || COALESCE ((SELECT ' <' || MIS.ValueData || '>' FROM MovementItem AS MI JOIN MovementItemString AS MIS ON MIS.MovementItemId = MI.Id AND MIS.DescId = zc_MIString_Comment() AND MIS.ValueData <> '' WHERE MI.MovementId = vbMovementId_2_Head AND MI.DescId = zc_MI_Message() AND MI.ObjectId = zc_Enum_PromoStateKind_Head() AND MI.isErased = FALSE ORDER BY MI.Id DESC LIMIT 1), '')
                          || '    � ' || (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_2_Head)
                          || ' �� '   || zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_2_Head))
                          || ' ������ ������ � ' || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_2_Head AND MD.DescId = zc_MovementDate_StartSale()))
                          || ' �� '              || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_2_Head AND MD.DescId = zc_MovementDate_EndSale()))
                    ELSE '��� �������������� ����������'
               END :: TVarChar
              ) :: TVarChar AS ValueText

              -- 1.1.
            , CASE WHEN vbCount_2_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsMsgColor = TRUE)
                        THEN -1 -- zc_Color_Black()
                   ELSE -1
              END AS ColorText_Addr
              -- 1.2.
            , CASE WHEN vbCount_2_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsMsgColor = TRUE)
                        THEN -1 -- zc_Color_Pink()
                   ELSE -1
              END AS Color_Addr
              -- 2.1.
            , CASE WHEN vbCount_2_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Text
              -- 2.2.
            , CASE WHEN vbCount_2_Head > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Pink()
                   ELSE -1
              END AS Color_Text

      UNION ALL
       -- 2.1.
       SELECT CASE WHEN vbCount_1_Main > 0
                        THEN vbMovementId_1_Main
                   WHEN vbCount_2_Main > 0
                        THEN vbMovementId_2_Main
                   ELSE -1
              END :: Integer AS MovementId

            , CASE WHEN vbIsUserSigning2 = TRUE THEN 1 ELSE 3 END :: Integer AS NPP
            , '��������������� ��������� : ' :: TVarChar AS MsgAddr
            , (CASE WHEN vbCount_1_Main > 0
                        THEN '������������ ���������� ��� ���������� '
                          || ' : '    || vbCount_1_Main :: TVarChar || ' ��.'
                          || COALESCE ((SELECT ' <' || MIS.ValueData || '>' FROM MovementItem AS MI JOIN MovementItemString AS MIS ON MIS.MovementItemId = MI.Id AND MIS.DescId = zc_MIString_Comment() AND MIS.ValueData <> '' WHERE MI.MovementId = vbMovementId_1_Main AND MI.DescId = zc_MI_Message() AND MI.ObjectId = zc_Enum_PromoStateKind_Main() AND MI.isErased = FALSE ORDER BY MI.Id DESC LIMIT 1), '')
                          || '    � ' || (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_1_Main)
                          || ' �� '   || zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_1_Main))
                          || ' ������ ������ � ' || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_1_Main AND MD.DescId = zc_MovementDate_StartSale()))
                          || ' �� '              || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_1_Main AND MD.DescId = zc_MovementDate_EndSale()))
                    ELSE '��� ������������ ����������'
               END :: TVarChar
              ) :: TVarChar AS ValueText

              -- 1.1.
            , CASE WHEN vbCount_1_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Black()
                   WHEN vbCount_2_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Addr
              -- 1.2.
            , CASE WHEN vbCount_1_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Lime()
                   WHEN vbCount_2_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Aqua()
                   ELSE -1
              END AS Color_Addr
              -- 2.1.
            , CASE WHEN vbCount_1_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Text
              -- 2.2.
            , CASE WHEN vbCount_1_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Lime()
                   ELSE -1
              END AS Color_Text

      UNION ALL
       -- 2.2.
       SELECT CASE WHEN vbCount_2_Main > 0
                        THEN vbMovementId_2_Main
                   ELSE -1
              END :: Integer AS MovementId

            , CASE WHEN vbIsUserSigning2 = TRUE THEN 2 ELSE 4 END :: Integer AS NPP
            , '' :: TVarChar AS MsgAddr
            , (CASE WHEN vbCount_2_Main > 0
                        THEN '������������ ��������� ��� ���������� '
                          || ' : '    || vbCount_2_Main :: TVarChar || ' ��.'
                          || COALESCE ((SELECT ' <' || MIS.ValueData || '>' FROM MovementItem AS MI JOIN MovementItemString AS MIS ON MIS.MovementItemId = MI.Id AND MIS.DescId = zc_MIString_Comment() AND MIS.ValueData <> '' WHERE MI.MovementId = vbMovementId_2_Main AND MI.DescId = zc_MI_Message() AND MI.ObjectId = zc_Enum_PromoStateKind_Main() AND MI.isErased = FALSE ORDER BY MI.Id DESC LIMIT 1), '')
                          || '    � ' || (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_2_Main)
                          || ' �� '   || zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_2_Main))
                          || ' ������ ������ � ' || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_2_Main AND MD.DescId = zc_MovementDate_StartSale()))
                          || ' �� '              || zfConvert_DateToString ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_2_Main AND MD.DescId = zc_MovementDate_EndSale()))
                    ELSE '��� �������������� ����������'
               END :: TVarChar
              ) :: TVarChar AS ValueText

              -- 1.1.
            , CASE WHEN vbCount_2_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsMsgColor = TRUE)
                        THEN -1 -- zc_Color_Black()
                   ELSE -1
              END AS ColorText_Addr
              -- 1.2.
            , CASE WHEN vbCount_2_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsMsgColor = TRUE)
                        THEN -1 -- zc_Color_Aqua()
                   ELSE -1
              END AS Color_Addr
              -- 2.1.
            , CASE WHEN vbCount_2_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Text
              -- 2.2.
            , CASE WHEN vbCount_2_Main > 0 AND (vbIsUserSigning1 = TRUE OR vbIsUserSigning2 = TRUE OR vbIsMsgColor = TRUE)
                        THEN zc_Color_Aqua()
                   ELSE -1
              END AS Color_Text

      UNION ALL
       -- 3.
       SELECT -1 :: Integer AS MovementId

            , 11 AS NPP
            , '����������� ����� :' :: TVarChar AS MsgAddr
            , ('���-�� ��������� = '    || vbCount_Contract :: TVarChar || ' ��.'
            || '  ������������� ���� �������� � <' || zfConvert_DateToString (vbOperDate_Contract_start) || '> �� <' || zfConvert_DateToString (vbOperDate_Contract) || '>'
              ) :: TVarChar AS ValueText

              -- 1.1.
            , CASE WHEN vbCount_Contract > 0
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Addr
              -- 1.2.
            , CASE WHEN vbCount_Contract > 0
                        THEN zc_Color_Aqua()
                   ELSE -1
              END AS Color_Addr
              -- 2.1.
            , CASE WHEN vbCount_Contract > 0
                        THEN zc_Color_Black()
                   ELSE -1
              END AS ColorText_Text
              -- 2.2.
            , CASE WHEN vbCount_Contract > 0
                        THEN zc_Color_Aqua()
                   ELSE -1
              END AS Color_Text
       WHERE vbIsMsg_Contract = TRUE

       ORDER BY 2
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.06.20                                        * add EnumName
*/

-- SELECT * FROM gpSelect_Object_GlobalMsg ('', zfCalc_UserAdmin())
