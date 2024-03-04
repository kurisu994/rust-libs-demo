#[cfg(target_os = "android")]
#[allow(non_snake_case)]
pub mod android;

#[cfg(feature = "clib")]
pub mod ios;