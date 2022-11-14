<script>
    export let type = 'primary';
    export let flat = false;
</script>

<button class:flat={flat} class={type} on:click>
    <slot></slot>
</button>

<style>
    button{
        border: 0;
        cursor: pointer;
        border-radius: 25px;
        padding: 10px 14px;
        font-weight: bold;
        font-size: large;
        box-shadow: 1px 2px 3px rgba(0,0,0,0.2);
    }
    .flat{
        box-shadow: none;
    }
    .primary{
        background: #6d6868;
        color: white;
    }
    .primary:hover {
        background: #b71a3d;
    }
    .secondary{
        background: #ff5900;
        color: white;
    }
    .secondary:hover {
        background: #ff4a00;
    }
</style>