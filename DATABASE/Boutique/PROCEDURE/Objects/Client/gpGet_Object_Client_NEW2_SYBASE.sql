-- Function: gpGet_Object_Client_NEW2_SYBASE()

DROP FUNCTION IF EXISTS gpGet_Object_Client_NEW2_SYBASE (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Client_NEW2_SYBASE(
    IN inName   TVarChar
)
RETURNS TVarChar
AS
$BODY$
BEGIN

     RETURN (WITH tmp AS 
(select tmp.Name, tmp.Name_new
from (
          select '5 ������� ����' as Name, '��������� ���������'  as Name_new
union all select '5 �������', '"5 �������"' 
union all select 'CC����� �����', '������ �����' 
union all select 'K���-���� 5 �������', '"5 �������"' 
union all select '�������� �����', '�������� �����' 
union all select '������� ����', '������� ��������' 
union all select '��������� �����������', '����������� ���������' 
union all select '���������� ������', '���������� �������' 
union all select '������� ���', '������� ����' 
union all select '����� �����', '�������� �����' 
union all select '���� �����', '���������� ����' 
union all select '������ ���', '������ �����' 
union all select '�������������� ������', '�������������� ������,��������' 
union all select '��������� �������', '��������� �������' 
union all select '������ �����', '������ ����� ��������' 
union all select '��������� ����', '��������� �����' 
union all select '����� �������', '����� �������' 
union all select '������� �������� ��������', '������� ��������� ��������' 
union all select '������ ��������� ��������', '������� ��������� ��������' 
union all select '������� ������, ����� �������', '������� ������ �����' 
union all select '��������� ���� ����', '��������� ��������� ����' 
union all select '������� ������', '������� �������� ����������' 
union all select '���������� �����', '���������� ��������' 
union all select '�������� ���', '�������� ����' 
union all select '����� ������', '����� ������, �����' 
union all select '��������  ���������', '�������� ���������' 
union all select '������� ���', '������� �����' 
union all select '���� �����', '���� ����� ����������' 
union all select '���������� ������', '���������� �������' 
union all select '�������� ������ ����', '������  �������� ����' 
union all select '������ ���� ����', '������ ��������� �����' 
union all select '��������� ��������', '��������� �������� �����������' 
union all select '�������������� �������', '������������� �������' 
union all select '�������� ������ ����������', '�������� ����� ����������' 
union all select '�������� �����', '�������� ����� �����������' 
union all select '����������   ���������', '���������� ���������' 
union all select '�������� ������', '�������� �������' 
union all select '�������� ���� ���', '�������� ��������� ���' 
union all select '����������� �����', '����������� �����' 
union all select '������� ��������', '������� �������' 
union all select '������ �����,����', '������ �����,�������' 
union all select '���� ������', '���� �����' 
union all select '������ ������ �����', '������ ������� �����' 
union all select '������ �������', '������ ������� �����' 
union all select '������� ���,����', '������� ����, ����' 
union all select '������� ����', '������� ����, ����' 
union all select '������� ���', '������� ����' 
union all select '������ ������', '������ ������' 
union all select '������� ����', '������� �������' 
union all select '������ ������', '������ ������ ���' 
union all select '������ ��� ����', '������ ������ ���' 
union all select '�������� ��������', '�������� ��������' 
union all select '���������� ����, ����', '���������� �������, ������' 
union all select '���� ���������', '��������� ����' 
union all select '������� �������', '������� �������' 
union all select '����� �������', '����� ������� �����������' 
union all select '��������� ������ ������', '���������  ������,������' 
union all select '�������+�����', '�������,�����' 
union all select '������� ����������', '������� ������� ����������' 
) as tmp
where Name_new <> '')

            SELECT trim (Name_new)
            FROM tmp
            where lower (trim (Name)) = lower (trim (inName))
              and inName <> ''
            -- limit 1
           )
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.04.18                                        *
*/

-- ����
-- SELECT * FROM gpGet_Object_Client_NEW2_SYBASE ('���� �������')
