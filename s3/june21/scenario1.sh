aws s3 mb s3://qtscenarios25june

aws s3 cp --recursive "C:\temp\ForS3\Videos" s3://qtscenarios25june/Videos
aws s3 mb s3://qtscenarios25june-1 --region 'ap-south-1'

aws s3 cp --recursive s3://qtscenarios25june/Videos s3://qtscenarios25june-1/Videos

aws s3 sync "C:\temp\ForS3\Videos" s3://qtscenarios25june/Videos

aws s3 sync s3://qtscenarios25june/Videos s3://qtscenarios25june-1/Videos


aws s3 cp --recursive "C:\temp\ForS3\Docs" s3://qtscenarios25june/Docs