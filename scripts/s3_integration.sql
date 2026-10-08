-- Create a storage integration with S3 and IAM role
CREATE OR REPLACE STORAGE INTEGRATION movielens_int
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = 'S3'
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::xxxxxxxxxxxx:role/snowflakerole'
    STORAGE_ALLOWED_LOCATIONS = ('s3://streaming-platform-dataset/');

-- Describe storage integration
DESC INTEGRATION movielens_int; 

-- Update the Trust relationships of the chose IAM role (snowflakerole in my case). Use STORAGE_AWS_IAM_USER_ARN in place of AWS_ROLE_ARN value and STORAGE_AWS_EXTERNAL_ID as value for the "sts:ExternalId" field

-- Create a file format
CREATE OR REPLACE FILE FORMAT my_csv_format
TYPE = 'CSV'
FIELD_DELIMITER = ','
RECORD_DELIMITER = '\n'
SKIP_HEADER = 1;

-- List file formats
SHOW FILE FORMATS;

-- Create an external S3 stage
CREATE OR REPLACE STAGE movielens_stage
    STORAGE_INTEGRATION = movielens_int
    URL = 's3://streaming-platform-dataset/'
    FILE_FORMAT = MY_CSV_FORMAT;

-- If the trust relationship between snowflake and IAM role (With full S3 access) is established properly, the query will produce a table listing all the files in the S3 bucket
LIST @movielens_stage;
