DO $$ 
BEGIN

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name = lower ('ResourseProtocol'))) 
      THEN
           CREATE TABLE ResourseProtocol (
              Id                    SERIAL NOT NULL, 
              UserId                INTEGER,
              OperDate              TDateTime, -- �� ������� �������� �����������
              Value1                INTEGER,   -- ������� ����� �������� ���������
              Value2                INTEGER,   -- ������� ����� ���������
              Value3                INTEGER,   -- ������� ��������� ������1
              Value4                INTEGER,   -- ������� ��������� ������2
              Value5                INTEGER,   -- ������� ��������� ������3
              Time1                 INTERVAL,  -- ������� ����� ����������� ����
              Time2                 INTERVAL,  -- ������� ����������� �� �����1
              Time3                 INTERVAL,  -- ������� ����������� �� �����2
              Time4                 INTERVAL,  -- ������� ����������� �� �����3
              Time5                 TDateTime, -- �� ������� �����������
              ProcName              TVarChar,  -- ����� ����. ������
              ProtocolData          TBlob,     -- ��������� ����.

              CONSTRAINT pk_ResourseProtocol PRIMARY KEY (Id)
           );

           CREATE INDEX idx_ResourseProtocol_UserId ON ResourseProtocol (UserId);
           CREATE INDEX idx_ResourseProtocol_OperDate ON ResourseProtocol (OperDate DESC);
      END IF;

      IF NOT (EXISTS (SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_name = lower ('ResourseItemProtocol'))) 
      THEN
           CREATE TABLE ResourseItemProtocol (
              Id                    SERIAL NOT NULL, 
              ParentId              INTEGER,
              pid                   INTEGER,   -- pid ��������
              query_start           TDateTime, -- �� ������� �����c� ����������� �������
              datname              TVarChar,  -- 
              usename              TVarChar,  -- 
              client_addr           TVarChar,  -- 
              state                 TVarChar,  -- 
              wait_event_type       TVarChar,  -- 
              wait_event            TVarChar,  -- 
              query                 TBlob,     -- ����.

              CONSTRAINT pk_ResourseItemProtocol PRIMARY KEY (Id)
           );

           CREATE INDEX idx_ResourseItemProtocol_ParentId ON ResourseItemProtocol (ParentId);
      END IF;

END;
$$;
