use std::ffi::{c_char, CStr, CString};

///
/// 简单hello
/// # Arguments
///
/// * `name`:  称呼
///
/// returns: 返回的字符串
///
#[no_mangle]
pub extern "C" fn say_hello(name: *const c_char,) -> *const c_char {
    let c_name = unsafe { CStr::from_ptr(name) };
    let recipient = c_name.to_str().unwrap_or_else(|_| "there");
    CString::new("Hello ".to_owned() + recipient).unwrap().into_raw()
}

///
///  释放由rust代码产生的字符串内存
/// # Arguments
///
/// * `str`:  由rust代码产生的字符串
///
/// returns: ()
///
#[no_mangle]
pub unsafe extern "C" fn free_str(str: *mut c_char) {
    unsafe {
        if str.is_null() { return }
        let _ = CString::from_raw(str);
    }
}