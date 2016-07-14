<!-- 生成查询条件 -->
<query-condition>
    <style scoped>
        .query-condition {
            margin-bottom:5px;
            background-color: white;
            padding: 5px;
        }
        .condition-row {
          margin-top: 5px;
          margin-bottom: 5px;
          padding-top: 5px;
        }
        .condition-row-more {
          border-top: 1px solid #ddd;
        }
        .condition-row:last-child {
          border-bottom: none;
        }
        .condition-label {
          min-width: 80px;
          margin-left:8px;
          margin-right:8px;
          display: inline-block;
          text-align: right;
        }
        .condition-cell {
          display: inline-block;
        }
        .condition-more {
          text-align: center;
          margin-top: 5px;
          margin-bottom: 10px;
        }
        .condition-more.visible {
          border-top:1px solid #ddd;
        }
        .condition-more span {
          border: 1px solid #ddd;
          border-top: 1px solid white;;
          margin: 0 auto;
          padding: 5px 16px;
          cursor: pointer;
          font-size: 8px;
        }
        .form-control {
          display:inline-block;
          width: 200px;
          min-width: 200px;
          vertical-align: middle;
        }
        input-field {
          display:inline-block;
        }
        /*
        .select2-container--bootstrap {
          display: inline-block;
        }
        .select2-container--bootstrap .select2-selection--single .select2-selection__rendered {
          padding: 0;
        }
        .select2-container--bootstrap .select2-selection--single {
          line-height: 30px;
        }
        */
        /*隐藏单选radio按钮*/
        .multiselect-container li input[type="radio"] {margin-left:-200px;}

    </style>

    <div class="query-condition">
        <form method="get" action="{ opts.action }">
            <div each={row, i in layout} show={i==0 || show} class={condition-row:true, condition-row-more:i>0}>
                <div each={field in row} class="condition-cell">
                   <span class="condition-label">{ fields[this.field].label || field }</span>
                   <input-field field={ fields[field] } data={data}
                     type={ fields[this.field].type || 'str' }>
                   </input-field>
                </div>
                <div show={ i==0 && !show } class="condition-cell" >
                    <button class="btn btn-primary btn-flat" type="submit">查询</button>
                    <button class="btn btn-default btn-flat" type="button" onclick={parent.reset}>清除条件</button>
                </div>
            </div>
            <div class="condition-row condition-row-more" show={show}>
              <button class="btn btn-primary btn-flat" type="submit">查询</button>
              <button class="btn btn-default btn-flat" type="button" onclick={reset}>清除条件</button>
            </div>
            <div class={condition-more:true, visible:layout.length>1}>
              <span if={layout.length > 1} href="#" onclick={ click }>
                { show? '收起' : '更多条件' }
                <i class={fa:true, fa-angle-up:show, fa-angle-down:!show}></i>
              </span>
            </div>
        </form>
    </div>

    <script>
      var self = this
      this.layout = opts.layout
      this.fields = {}

      // 初始化fields.name
      opts.fields.forEach(function(v){
        self.fields[v['name']] = v
      })
      this.show = false
      // 使用 query_string 初始化值, 定义在uliweb-ui.js中
      this.data = $.extend({}, $.query_string.urlParams, opts.data)

      if (!this.layout) {
          this.layout = []
          var s = []
          this.layout.push(s)
          for (k in this.fields) {
              s.push(k);
          }
      }

      this.click = function(e){
        self.show = !self.show
      }

      this.reset = function(e){
        for (k in self.fields) {
          var field = self.fields[k]
          if (field.type == 'select' && field.url) {
            $('[name='+k+']', self.root).val('').trigger('change')
          }
          else if (field.type == 'select') {
            // $('[name='+k+']', self.root).select2().val(null)
            $('[name='+k+']', self.root)
              .multiselect('deselectAll', false)
              .multiselect('updateButtonText')
          } else
            $('[name='+k+']', self.root).val(null)
        }
      }

      // this.on('mount', function(){
      //   for (k in self.data){
      //     $('[name='+k+']').val(self.data[k]);
      //   }
      // })
    </script>
</query-condition>

<input-field>
    <input type="text" name={ opts.field.name } class="form-control" field-type="str"
      if={opts.type=='str' || opts.type=='unicode'} placeholder={opts.field.placeholder}/>

    <input type="password" name={ opts.field.name } class="form-control" field-type="password"
      if={opts.type=='password'} placeholder={opts.field.placeholder}/>

    <select multiple={opts.field.multiple} if={opts.type=='select'}
      field-type="select" style="width:200px" name={opts.field.name} url={opts.field.url} placeholder={opts.field.placeholder}>
      <option each={value in opts.field.choices} value={value[0]}>
          {value[1]}
      </option>
    </select>

    <input type="text" name={ opts.field.name} class="form-control" field-type="date"
      if={opts.type=='date'} placeholder={opts.field.placeholder}/>

    <input type="text" name={ opts.field.name} class="form-control" field-type="datetime"
      if={opts.type=='datetime'} placeholder={opts.field.placeholder}/>

    <script>
    var self = this

    this.on('mount', function(){
      // if (opts.type == 'select' && !opts.field.multiple){
      //   var _opts = $.extend({}, {width:'resolve', allowClear:true, minimumResultsForSearch: Infinity,
      //     placeholder:opts.field.placeholder,
      //     theme:'bootstrap', language:'zh_CN'}, opts.field.opts || {})
      //   load('ui.select2', function(){
      //     var el = $('[name='+opts.field.name+']', self.root).select2(_opts);
      //     if (opts.data[opts.field.name])
      //       el.val(opts.data[opts.field.name])
      //     return
      //   })
      // } else

      var i18n = { // 本地化
        previousMonth	: '上个月',
        nextMonth		: '下个月',
        months			: ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'],
        weekdays		: ['周日','周一','周二','周三','周四','周五','周六'],
        weekdaysShort	: ['日','一','二','三','四','五','六']
      }

      if (opts.type == 'select' && opts.field.url){
        load('ui.select2', function(){
          var el = $('[name='+opts.field.name+']', self.root);
          simple_select2(el, {width:'resolve'})
        })
      }else if (opts.type == 'select') {
        var _opts = $.extend({}, {
            includeSelectAllOption: true,
            selectAllText: '全部选中',
//            enableFiltering: true,
//            enableCaseInsensitiveFiltering: true,
            buttonClass: 'btn btn-default btn-flat',
            numberDisplayed: 2,
            selectedClass: '',
            nonSelectedText: opts.field.placeholder || '请选择',
            maxHeight: 200
            }, opts.field.opts || {})
        load('ui.bootstrap.multiselect', function(){
          var el = $('[name='+opts.field.name+']', self.root).multiselect(_opts);
          if (opts.data[opts.field.name])
            el.multiselect('select', opts.data[opts.field.name])
        })
      } else if (opts.type == 'date') {
        var _opts = {format: 'YYYY-MM-DD', showTime:false, i18n:i18n};
        load('ui.pikaday', function(){
          $('[name='+opts.field.name+']').pikaday(_opts);
        })
      } else if (opts.type == 'datetime') {
        var _opts = {format: 'YYYY-MM-DD hh:mm:ss', showTime:true, use24hour:true, i18n:i18n}
        load('ui.pikaday', function(){
          $('[name='+opts.field.name+']').pikaday(_opts);
        })
      } else {
      }
      if (opts.data[opts.field.name])
        $('[name='+opts.field.name+']').val(opts.data[opts.field.name])


    })
    </script>
</input-field>