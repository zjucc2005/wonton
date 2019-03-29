// Put your application scripts here

/*-- validation before registration --*/
function validate_params_of_reg(locale){
    var email_taken = {
        zh_cn: '邮箱已被使用',
        en: 'email is taken'
    };
    var password_too_short = {
        zh_cn: '密码必须大于等于6位',
        en: 'Password length must be greater than or equal to 6 digits'
    };
    var password_too_long = {
        zh_cn: '密码必须小于等于40位',
        en: 'Password length must be less than or equal to 40 digits'
    };
    var password_not_match = {
        zh_cn: '两次输入的密码不一致',
        en: 'The two passwords you entered were inconsistent'
    };
    var email = $('#signup_form>input[name=email]').val();
    var pwd  = $('#signup_form>input[name=password]').val();
    var pwdc = $('#signup_form>input[name=password_confirmation]').val();
    if(email_is_taken(email)){
        alert(email_taken[locale]);
        return false;
    }else if(pwd.length < 6){
        alert(password_too_short[locale]);
        return false;
    }else if(pwd.length > 40){
        alert(password_too_long[locale]);
        return false;
    }else if(pwd != pwdc){
        alert(password_not_match[locale]);
        return false;
    }
    return true;
}

function email_is_taken(email){
    var result = false;
    $.ajax({
        type: 'GET',
        dataType: 'json',
        async: false,
        url: '/accounts/existed',
        data: { email: email },
        success: function(data){
            if(data.status == 'succ' && data.existed == true){
                result = true;
            }
        }
    });
    return result;
}

/*-- product showcase --*/
function load_product_showcase(product_id){
    var ele = document.getElementById('product_' + product_id);
    if(ele.dataset.loaded == 'true'){
        return true;  // 不再重复加载
    }else{
        $.ajax({
            type: 'GET',
            dataType: 'json',
            async: false,
            url: '/products/' + product_id + '/showcase',
            success: function(data){
                if(data.status == 'succ'){
                    $(ele).html(data.html);
                    ele.dataset.loaded = 'true';
                }else{
                    alert(data.reason);
                }
            }
        });
    }
}
function collect_product(product_id){
    $.ajax({
        type: 'POST',
        dataType: 'json',
        async: false,
        url: '/products/' + product_id + '/collect',
        success: function(data){
            if(data.status == 'succ'){
                $('#collect_btn_'+ product_id).html(data.html);
            }else{
                alert(data.reason);
            }
        }
    })
}
function cancel_collect_product(product_id){
    $.ajax({
        type: 'POST',
        dataType: 'json',
        async: false,
        url: '/products/' + product_id + '/cancel_collect',
        success: function(data){
            if(data.status == 'succ'){
                $('#collect_btn_'+ product_id).html(data.html);
            }else{
                alert(data.reason);
            }
        }
    })
}