---
title: "README.md"
author: "Kevin Fowler"
date: "August 18, 2015"
output: html_document
---

The column names for the mean and standard deviation of measured variables for each subject/activity follow a consistent camelCase format:

domainSourceType[Jerk][Mean|StdDev][XYZ|Magnitude]

These label parts (or fields) are each described here:

+ domain: Indicating *time* for time-domain or *freq* for frequency-domain measurement

+ Source: Indicating *Body* or *Gravity* as the source of the force producing the acceleration. *Gravity* can only generate linear acceleration, while the *Body* can generate both linear and angular(rotational) accelerations

+ Type: Indicating the type of acceleration as either *Linear* (measured by the accelerometer) or *Angular* (measured by the gyroscope)

+ \[Jerk]: Indicating whether the acceleration is normal/smooth or a sudden *Jerk*. If not a *Jerk*, then this field is missing from the column name

+ [Mean|StdDev]: Indicating whether this is the *Mean* or the *StdDev* (standard deviation) numerical summary of the raw acceleration data for this measurement

+ [XYZ|Magnitude]: Indicating whether this is a numerical summary of a single component (*X*, *Y* or *Z*) or the *Magnitude* of the acceleration measurement  

For example:

+ *timeBodyLinearJerkStdDevY* is the standard deviation of the Y-component of the time-domain measurement of the body's linear jerk(sudden, or high frequency) acceleration

+ *freqBodyAngularMeanMagnitude* is the mean of the magnitude of the frequency-domain measurement of the body's angular acceleration.