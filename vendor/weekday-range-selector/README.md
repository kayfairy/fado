# Weekday Range Selector

Select time periods like `Mo-Fr`.

## Usage

Change values at start, setting the data attributes for each canvas or setting the option `start`.

```html
<div id="container" class="slider-weekday-container" data-start="0" data-stop="4">
[...]
</div>

<script>
    var selector = WeekDayRangeSelector('container');
</script>
```

## Options

Start values can be set with option `start` _weekday number [0-6]_ and `stop` _weekday number [0-6]_.

Events are `onMove` and `onChange`.

```javascript
WeekDayRangeSelector(
    'container',
    {
        start: 0,
        stop: 5,
        locale: ['en-US', {weekday: 'short', year: 'numeric', month: 'short', day: 'numeric'}],
        onMove: function(event) {
            console.log(event.start, event.stop);
        },
        onChange: function(event) {
            event.preventDefault();
        }
    }
);
```

## Form values

The value for `Monday to Friday` is `0-4`.

```html
<input type="hidden" name="weekdayrange" class="input" value="5-6">
```

## License

[GPLv3 License](https://www.gnu.org/licenses/gpl-3.0.en.html) © 2019 Fatih Kaymak
